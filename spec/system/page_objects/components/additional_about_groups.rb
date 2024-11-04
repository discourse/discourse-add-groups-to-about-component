module PageObjects
  module Components
    class AdditionalAboutGroups < PageObjects::Components::Base
      def has_group_with_name?(name)
        has_css?(".about__#{name.downcase} h3", text: name)
      end

      def has_no_group_with_name?(name)
        has_no_css?(".about__#{name} h3", text: name)
      end

      def has_group_with_member?(username)
        has_css?(".about-page-users-list .user-info[data-username='#{username}']")
      end

      def has_no_group_with_member?(username)
        has_no_css?(".about-page-users-list .user-info[data-username='#{username}']")
      end

      def has_loading_spinner?
        has_css?('.loading-container .spinner')
      end

      def has_no_loading_spinner?
        has_no_css?('.loading-container .spinner')
      end
    end
  end
end