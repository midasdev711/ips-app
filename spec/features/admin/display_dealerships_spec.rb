require 'feature_helper'

RSpec.feature 'Displaying dealerships in admin', type: :feature do
  let(:admin) { create :admin }

  background do
    create :dealership, name: 'Murray Mazda Chilliwack BC'
    create :dealership, name: 'Brooks MotorProducts'

    login_as(admin, :scope => :user)
  end

  scenario 'Admin sees the list of dealerships ordered by name' do
    visit '/'

    names = page.find('main').all('article.dealership > h2 > a').map(&:text)

    expect(names).to eql(names.sort)
  end
end
