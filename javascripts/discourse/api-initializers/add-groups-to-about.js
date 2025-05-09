import { apiInitializer } from "discourse/lib/api";
import AdditionalAboutGroups from "../components/additional-about-groups";

export default apiInitializer("1.14.0", (api) => {
  const siteSettings = api.container.lookup("service:site-settings");

  // Functionality is moving into core.
  if (siteSettings.show_additional_about_groups === true) {
    return;
  }

  api.renderInOutlet("about-after-moderators", AdditionalAboutGroups);
});
