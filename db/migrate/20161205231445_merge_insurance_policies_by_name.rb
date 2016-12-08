class MergeInsurancePoliciesByName < ActiveRecord::Migration[5.0]
  def up
    ProductList.all.each do |product_list|
      product_list.insurance_policies.group_by{ |p| p.name.to_s.strip }.each do |name, insurance_policies|
        category, loan = insurance_policies.first.category, insurance_policies.first.loan

        joint_insurance_policy = InsurancePolicy.create name: name, category: category, loan: loan, product_list: product_list

        insurance_policies.each do |insurance_policy|
          insurance_policy.insurance_rates.each do |insurance_rate|
            insurance_rate.update_columns insurance_policy_id: joint_insurance_policy.id
          end

          insurance_policy.insurance_terms.each do |insurance_term|
            insurance_term.update_columns insurance_policy_id: joint_insurance_policy.id
          end

          insurance_policy.reload.destroy
        end
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
