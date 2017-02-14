require 'feature_helper'

RSpec.feature 'Creating deal', type: :feature do
  let!(:manager) { create :manager }

  background do
    login_as(manager, :scope => :user)
  end

  scenario 'Manager creates new deal' do
    visit '/deals'

    click_link 'Add new deal'

    fill_in 'Name', with: 'Joe Doe'
    fill_in 'Email', with: 'joe@example.com'
    fill_in 'Phone', with: '18009998877'

    click_button 'Create Deal'

    expect(page).to have_content('Deal was successfully created.')
  end
end
