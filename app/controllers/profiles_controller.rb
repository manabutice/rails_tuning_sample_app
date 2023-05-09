class ProfilesController < ApplicationController
  def index
    @user = User.find(1)
    raise Forbidden unless user_safe?

    @skill_categories = user_reccomend_skill_categories
    @articles = @user.articles.preload(:tags)
  end

  private

  def user_safe?
    # @user.user_cautions.all? do |user_caution|
    #   Time.zone.now > user_caution.caution_freeze.end_time
    @user.user_cautions.joins(:caution_freeze).
    where("caution_freezes.end_time > ?", Time.zone.now).blank?
    
  end

  def user_reccomend_skill_categories
    # @user.skills.map(&:skill_category).
    #   filter { |skill_category| skill_category.reccomend }.uniq
      SkillCategory.eager_load(:skills).
        where(reccomend: true).
        where(skills: { user_id: @user.id})
  end
end
