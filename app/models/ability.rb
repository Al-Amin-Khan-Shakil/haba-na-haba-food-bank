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
    can :read, Notification, user_id: user.id
    can :read, Branch, id: user.branch_id
    can :update, User, id: user.id
    can :read, Event
    can :read, District
    can :read, County
    can :read, SubCounty
    common_permissions(user)
  end

  def common_permissions(user)
    can :manage, Inventory, lambda { |inventory|
      inventory.branch_id == user.branch_id || user.event_ids.include?(inventory.event_id)
    }
    can :manage, IndividualBeneficiary, lambda { |beneficiary|
      beneficiary.branch_id == user.branch_id || user.event_ids.include?(beneficiary.event_id)
    }
    can :manage, FamilyBeneficiary, lambda { |beneficiary|
      beneficiary.branch_id == user.branch_id || user.event_ids.include?(beneficiary.event_id)
    }
    can :manage, OrgainzationBeneficiary, lambda { |beneficiary|
      beneficiary.branch_id == user.branch_id || user.event_ids.include?(beneficiary.event_id)
    }
    can :read, User, lambda { |u|
      %w[branch_manager volunteer].include?(u.role) && u.branch_id == user.branch_id
    }
  end
end
