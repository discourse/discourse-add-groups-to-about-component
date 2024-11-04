# frozen_string_literal: true

require_relative "page_objects/components/additional_about_groups"

RSpec.describe "Additional About Groups", type: :system do
  fab!(:group1) { Fabricate(:group, name: "group1") }
  fab!(:group2) { Fabricate(:group, name: "group2") }
  let!(:member1) { Fabricate(:user, username: "user1", groups: [group1]) }
  let!(:member2) { Fabricate(:user, username: "user2", groups: [group2]) }
  let!(:theme) { upload_theme_component }
  let(:about_groups_component) { PageObjects::Components::AdditionalAboutGroups.new }

  before do
    theme.update_setting(:about_groups, "#{group1.id}|#{group2.id}")
    theme.save!
  end

  it "renders the groups specified in the about_groups theme setting" do
    visit "/about"

    expect(about_groups_component).to have_group_with_name("Group1")
    expect(about_groups_component).to have_group_with_name("Group2")
    expect(about_groups_component).to have_group_with_member("user1")
    expect(about_groups_component).to have_group_with_member("user2")
  end

  it "does not display groups not included in the about_groups theme setting" do
    theme.update_setting(:about_groups, "#{group1.id}")
    theme.save!

    visit "/about"

    expect(about_groups_component).to have_group_with_name("Group1")
    expect(about_groups_component).to have_no_group_with_name("Group2")
    expect(about_groups_component).to have_group_with_member("user1")
    expect(about_groups_component).to have_no_group_with_member("user2")
  end
end
