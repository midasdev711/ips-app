class Ability
  include CanCan::Ability

  def initialize(user)
    if user.admin?
      can :manage, :all
    end

    if user.financial_manager?
      can :manage, User, id: user.id
      can :manage, Deal, user_id: user.id
      can :manage, ProductList do |pl|
        pl.listable == user || pl.listable.user == user
      end
    end
  end
end
