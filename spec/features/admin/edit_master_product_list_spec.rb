require 'feature_helper'

RSpec.xfeature 'Edit master product list', type: :feature, js: true do
  let(:admin) { create :admin }
  let!(:product_list) { create :blank_master_product_list, listable: admin }

  background do
    login_as(admin, :scope => :user)
  end

  CATEGORY_INDEX = {
    pocketbook: 0,
    car: 1,
    family: 2
  }

  POLICY_TITLES = {
    finance: 'Finance',
    lease: 'Lease',
    lease_with_residual: 'Lease with Residual'
  }

  POLICY_INDEXES = {
    finance: 0,
    lease: 1,
    lease_with_residual: 2
  }

  def add_insurance_policy_variation(cat_index, pol_context, type, term, rate)
    pol_title = POLICY_TITLES[type]
    var_index = POLICY_INDEXES[type]

    # page.save_screenshot('form.png')

    # binding.pry

    pol_context.find(:xpath, "(.//div/div/div/a[text()[contains(., '#{pol_title}')]])[1]").click

    pol_context.select(term, from: "product_list_insurance_policies_attributes_#{cat_index}_insurance_rates_attributes_#{var_index}_term")
    pol_context.fill_in("product_list_insurance_policies_attributes_#{cat_index}_insurance_rates_attributes_#{var_index}_value", with: rate)
  end

  def add_items_to_product_list_form(items)
    items.each do |cat_name, cat_items|
      cat_index = CATEGORY_INDEX[cat_name]
      cat_context = page.find(:xpath, "//form//h3[contains(text(), '#{cat_name}')]/../../..")

      (cat_items[:products] || {}).each_with_index do |(prod_name, prod_values), prod_index|
        cat_context.find(:xpath, './/ul/li/a[contains(text(), "Add Product")]').click

        cat_context.fill_in("product_list_products_attributes_#{cat_index}_name", with: prod_name)
        cat_context.select(prod_values[:tax], from: "product_list_products_attributes_#{cat_index}_tax")
        # page.evaluate_script("$('#product_list_products_attributes_#{cat_index}_retail_price').autoNumeric('set', '#{prod_values[:retail_price]}')")
        # page.evaluate_script("$('#product_list_products_attributes_#{cat_index}_dealer_cost').autoNumeric('set', '#{prod_values[:dealer_cost]}')")
        cat_context.fill_in("product_list_products_attributes_#{cat_index}_retail_price", with: prod_values[:retail_price])
        cat_context.fill_in("product_list_products_attributes_#{cat_index}_dealer_cost", with: prod_values[:dealer_cost])

        page.evaluate_script("$('#product_list_products_attributes_#{cat_index}_retail_price').autoNumeric('update')")
        page.evaluate_script("console.log($('#product_list_products_attributes_#{cat_index}_retail_price').val())")
        page.evaluate_script("console.log($('#product_list_products_attributes_#{cat_index}_retail_price').autoNumeric('get'))")
        page.evaluate_script("console.log($('#product_list_products_attributes_#{cat_index}_retail_price_val').val())")
      end

      (cat_items[:insurance_policies] || {}).each do |pol_name, variations|
        cat_context.find(:xpath, './/*/a[contains(text(), "Add Insurance")]').click

        fill_in("product_list_insurance_policies_attributes_#{cat_index}_name", with: pol_name)

        pol_context = cat_context.find_by_id("#{cat_name}-insurance-policies")

        variations.each do |var_type, var_values|
          add_insurance_policy_variation(cat_index, pol_context, var_type, var_values[:term], var_values[:rate])
        end
      end
    end
  end

  scenario 'Admin adds products and insurance policies to category' do
    visit '/product_list/edit'

    add_items_to_product_list_form(
      pocketbook: {
        products: {
          'Master Pocketbook Product 1' => {
            tax: 'One Tax',
            retail_price: '225',
            dealer_cost: '25'
          }
        },
        # insurance_policies: {
        #   'Master Pocketbook Insurance 1' => {
        #     finance: {
        #       term: '12',
        #       rate: '0.1'
        #     },
        #     lease: {
        #       term: '24',
        #       rate: '0.2'
        #     },
        #     lease_with_residual: {
        #       term: '36',
        #       rate: '0.3'
        #     },
        #   }
        # }
      },
      # car: {
      #   products: {
      #     'Master Car Product 1' => {
      #       tax: 'One Tax',
      #       retail_price: '325',
      #       dealer_cost: '225'
      #     }
      #   },
      #   insurance_policies: {
      #     'Master Car Insurance 1' => {
      #       finance: {
      #         term: '12',
      #         rate: '0.1'
      #       }
      #     }
      #   }
      # },
      # family: {
      #   products: {
      #     'Master Family Product 1' => {
      #       tax: 'One Tax',
      #       retail_price: '725',
      #       dealer_cost: '425'
      #     }
      #   },
      #   insurance_policies: {
      #     'Master Family Insurance 1' => {
      #       lease: {
      #         term: '24',
      #         rate: '0.3'
      #       }
      #     }
      #   }
      # }
    )

    page.save_screenshot('form1.png', full: true)

    # print page.html

    click_button 'Save product list'

    page.save_screenshot('form2.png', full: true)


    expect(page).to have_content('Product List was successfully updated')
  end
end
