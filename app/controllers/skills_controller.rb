class SkillsController < ApplicationController

  # GET /skills
  def index
    @skills = Skill.all
    json_response(@skills)
  end

  # GET /skill/:id
  def show
    json_response(@skill)
  end

  # POST /skills
  def create
    @skill = Skill.create(skill_params)
    json_response(@skill, :created)
  end

  # PUT /skills/:id
  def update
    @skill.update!(skill_params)
    head :no_content
  end

  # DELETE /skills/:id
  def destroy
    @skill.destroy
    head :no_content
  end

  private

  def skill_params
    # whitelist paramss
    params.permit(:name)
  end

  def set_skill
    @skill = Skill.find(params[:id])
  end

end
