import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";
import { service } from "@ember/service";
import AboutPageUsers from "discourse/components/about-page-users";
import ConditionalLoadingSpinner from "discourse/components/conditional-loading-spinner";

export default class AdditionalAboutGroups extends Component {
  @service store;
  @service site;
  @tracked groups = [];
  @tracked loading = false;

  constructor() {
    super(...arguments);
    this.loadGroups();
  }

  groupName(group) {
    return group.full_name || group.name.replace(/_/g, " ");
  }

  @action
  async loadGroups() {
    this.loading = true;
    try {
      const groupsSetting = settings.about_groups?.split("|").map(Number) || [];

      const groupsToFetch = this.site.groups.filter((group) =>
        groupsSetting.includes(group.id)
      );

      const groupPromises = groupsToFetch.map(async (group) => {
        try {
          group.members = await this.loadGroupMembers(group.name);
          return group;
        } catch (error) {
          console.error(
            `Error loading members for group ${group.name}:`,
            error
          );
          return null;
        }
      });

      const groupsWithMembers = (await Promise.all(groupPromises)).filter(
        (group) => group && group.members.length > 0
      );

      this.groups = groupsWithMembers;
    } catch (error) {
      // eslint-disable-next-line no-console
      console.error("Error loading groups:", error);
      this.groups = [];
    } finally {
      this.loading = false;
    }
  }

  async loadGroupMembers(groupName) {
    try {
      const response = await fetch(
        `/groups/${groupName}/members.json?offset=0&order=&asc=true`
      );
      const data = await response.json();
      return data.members || [];
    } catch (error) {
      // eslint-disable-next-line no-console
      console.error(`Error loading members for group ${groupName}:`, error);
      return [];
    }
  }

  <template>
    <ConditionalLoadingSpinner @condition={{this.loading}}>
      {{#if this.groups}}
        {{#each this.groups as |group|}}
          <section class="about__{{group.name}} --custom-group">
            <h3>{{this.groupName group}}</h3>
            <div class="about-page-users-list">
              <AboutPageUsers
                @users={{group.members}}
                @truncateAt={{settings.show_initial_members}}
              />
            </div>
          </section>
        {{/each}}
      {{/if}}
    </ConditionalLoadingSpinner>
  </template>
}
