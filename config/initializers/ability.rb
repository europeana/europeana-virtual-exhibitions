Alchemy::Devise::Ability.class_eval do
  def initialize(user)
    @user = user

    can :signup, Alchemy::User
    can :create, Alchemy::User if Alchemy::User.count == 0

    if member? || author? || editor?
      can [:show, :update], Alchemy.user_class, id: user.id
    end

    if editor? || admin?
      can :index, :alchemy_admin_users
      can :read, Alchemy.user_class
    end

    if admin?
      can :manage, Alchemy.user_class
    end

    if editor?
      cannot :edit, Alchemy::Page do |page|
        page.creator_id != user.id
      end

      cannot :publish, Alchemy::Page
    end
  end
end
