class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    case user.role
    when 'volunteer'
      volunteer_permissions(user)
    when 'branch_manager'
      branch_manager_permissions(user)
    when 'admin'
      admin_permissions(user)
    when 'super_admin'
      super_admin_permissions(user)
    else
      guest_permissions(user)
    end
  end

  private

  def volunteer_permissions(user)
    can %i[read update], Request, user_id: user.id
    can :read, Branch, id: user.branch_id
    can :read, Event, event_users: { user_id: user.id }
    can :read, District
    can :read, County
    can :read, SubCounty
    common_permissions(user)
  end

  def branch_manager_permissions(user)
    can :manage, Request, branch_id: user.branch_id
    can %i[read update], Branch, id: user.branch_id
    can %i[read create update], Event
    can %i[create destroy], User do |u|
      u.role == 'volunteer' && u.branch_id == user.branch_id
    end
    can :manage, District
    can :manage, County
    can :manage, SubCounty
    common_permissions(user)
  end

  def admin_permissions(user)
    can :manage, :all
  end

  def super_admin_permissions(user)
    can :manage, :all
  end

  def guest_permissions(user)
    can :read, :sign_up
  end

  def common_permissions(user)
    can :update, User, id: user.id
    can %i[read update], Notification, user_id: user.id
    can :manage, Inventory do |inventory|
      inventory.branch_id == user.branch_id || user.event_ids.include?(inventory.event_id)
    end
    can :manage, IndividualBeneficiary do |beneficiary|
      beneficiary.branch_id == user.branch_id || user.event_ids.include?(beneficiary.event_id)
    end
    can :manage, FamilyBeneficiary do |beneficiary|
      beneficiary.branch_id == user.branch_id || user.event_ids.include?(beneficiary.event_id)
    end
    can :manage, OrganizationBeneficiary do |beneficiary|
      beneficiary.branch_id == user.branch_id || user.event_ids.include?(beneficiary.event_id)
    end
    can :read, User, role: %w[branch_manager volunteer], branch_id: user.branch_id
  end
end