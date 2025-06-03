import { addGlobalNotice } from "discourse/components/global-notice";
import { apiInitializer } from "discourse/lib/api";
import AdditionalAboutGroups from "../components/additional-about-groups";

export default apiInitializer("1.14.0", (api) => {
  const siteSettings = api.container.lookup("service:site-settings");
  const currentUser = api.container.lookup("service:current-user");

  if (currentUser?.staff) {
    addGlobalNotice(
      `<b>Admin notice:</b> you're using the <em>discourse-add-groups-to-about</em> theme component. This feature is now available in Discourse core. You should remove this theme component.`,
      "add-groups-to-about-component",
      {
        dismissable: true,
        level: "warn",
        dismissDuration: moment.duration("1", "hour"),
      }
    );
  }

  // Functionality is moving into core.
  if (siteSettings.show_additional_about_groups === true) {
    return;
  }

  api.renderInOutlet("about-after-moderators", AdditionalAboutGroups);
});
