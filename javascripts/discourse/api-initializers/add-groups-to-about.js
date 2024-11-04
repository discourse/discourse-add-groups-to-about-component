import { apiInitializer } from "discourse/lib/api";
import AdditionalAboutGroups from "../components/additional-about-groups";

export default apiInitializer("1.14.0", (api) => {
  api.renderInOutlet("about-after-moderators", AdditionalAboutGroups);
});
