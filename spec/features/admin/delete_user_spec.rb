require 'feature_helper'

RSpec.feature 'User deletion', type: :feature, js: true do
  let!(:admin) { create :admin }
  let!(:dealership) { create :dealership }
  let!(:user) { create :user, dealership: dealership }

  background do
    login_as(admin, :scope => :user)

    visit "/dealerships/#{dealership.id}/users"
  end

  scenario 'Admin deletes user' do
    accept_confirm do
      click_link("btn-delete-user-#{user.id}")
    end

    expect(page).to have_css('.alert-box.success', text: 'User was successfully deleted.')

    expect(page).to_not have_css('#dealership-users')
  end
end
