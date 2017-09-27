shared_examples 'a Jira instance properly setup' do |database_examples|
  describe 'Going through the setup process' do
    # For <7.5.0 (not sure when it changed)
    # before :all do
    #   until current_path =~ %r{/secure/SetupMode!default.jspa}
    #     visit '/'
    #     sleep 1
    #   end
    # end
    #
    # subject { page }
    #
    # context 'when visiting the root page' do
    #   it { is_expected.to have_current_path %r{/secure/SetupMode!default.jspa} }
    #   it { is_expected.to have_css 'form#jira-setup-mode' }
    #   it { is_expected.to have_css 'div[data-choice-value=classic]' }
    # end
    #
    # context 'when manually setting up the instance' do
    #   before :all do
    #     within 'form#jira-setup-mode' do
    #       find(:css, 'div[data-choice-value=classic]').trigger('click')
    #       click_button 'Next'
    #       wait_for_ajax
    #     end
    #   end
    #
    #   it { is_expected.to have_current_path %r{/secure/SetupDatabase!default.jspa} }
    #   it { is_expected.to have_css 'form#jira-setup-database' }
    #   it { is_expected.to have_selector :radio_button, 'jira-setup-database-field-database-internal' }
    #   it { is_expected.to have_button 'Next' }
    # end
    #
    # context 'when processing database setup' do
    #   include_examples database_examples
    #
    # End commented <7.5.0 portion

    # For >=7.5.0
    before :all do
      until current_path =~ %r{/secure/SetupApplicationProperties!default.jspa}
        visit '/'
        sleep 1
      end
    end

    subject { page }

    context 'when visiting the root page, landing on application properties setup' do
    # End >=7.5.0 portion

      it { is_expected.to have_current_path %r{/secure/SetupApplicationProperties!default.jspa} }
      it { is_expected.to have_css 'form#jira-setupwizard' }
      it { is_expected.to have_field 'title' }
      it { is_expected.to have_selector :radio_button, 'jira-setupwizard-mode-public' }
      it { is_expected.to have_field 'baseURL' }
      it { is_expected.to have_button 'Next' }
    end

    context 'when processing application properties setup' do
      before :all do
        within 'form#jira-setupwizard' do
          fill_in 'title', with: 'JIRA Test instance'
          choose 'jira-setupwizard-mode-public'
          click_button 'Next'
        end
      end

      it { is_expected.to have_current_path %r{/secure/SetupLicense!default.jspa} }
      it { is_expected.to have_css 'form#jira-setupwizard' }
      it { is_expected.to have_css '#importLicenseForm' }
      it { is_expected.to have_button 'Next' }
    end

    context 'when processing license setup' do
      before :all do
        within '#jira-setupwizard' do
          within '#importLicenseForm' do
            # For <7.5.0 (not sure when it changed)
            # fill_in 'licenseKey', with: '1'
            # For >=7.5.0
            fill_in 'licenseKey', with: 'AAABdA0ODAoPeNp9UUtvgkAQvvMrSHppDxAW+9JkkypsUhpFK9j00MuIo24DC5ldbPvvi2LTl3r8Zne+15yl69pOsLJ9Znt+74r1WNcOwtT2PXZjrQhRrcuqQnKHMkOlUSykkaXiIk7FdDKNEmHFdTFHGi9nGklzh1mvksD9N53UlK1BYwgG+Zbe8bqOz6w9cfpRYQwF8mA8GolpEPWHX0/ivZL08b3HvO1eUCoDmREjkDnHogBVY+7qTALB3apopm5WFlaCtEGKQj6YRYnTGQxSJ7l8nDjx5f1167SiclFnxt0CR5dL8waEbkMtN8gN1dh+O17AgZoOpWmMKoMKVHYk0Qk3/9rc6zS5hlGYiNgZMq9zzW67vtUg/ntygjgxQAaJLyHXaI1pBUpq2CV8xrkEKyDcwb9ny1sDT42f7Wf/VwvYBKWKpN4XGKLOSFY72odo2reTvb593t7n4qVniw3k9U6rNXzsAoe6/Sn+c++bs8WfJYkASDAsAhRkXsMnXzDiDiWvT2Wge4K/d6yb2AIUTDzaeKDy8DXOzOBnZSEOhjhezBU=X02i6'
            click_button 'Next'
            wait_for_location_change
          end
        end
      end

      it { is_expected.to have_current_path %r{/secure/SetupAdminAccount!default.jspa} }
      it { is_expected.to have_field 'fullname' }
      it { is_expected.to have_field 'email' }
      it { is_expected.to have_field 'username' }
      it { is_expected.to have_field 'password' }
      it { is_expected.to have_field 'confirm' }
      it { is_expected.to have_button 'Next' }
    end

    context 'when processing administrative account setup' do
      before :all do
        within '#jira-setupwizard' do
          fill_in 'fullname', with: 'Continuous Integration Administrator'
          fill_in 'email', with: 'jira@circleci.com'
          fill_in 'username', with: 'admin'
          fill_in 'password', with: 'admin'
          fill_in 'confirm', with: 'admin'
          click_button 'Next'
        end
      end

      it { is_expected.to have_current_path %r{/secure/SetupAdminAccount.jspa} }
      it { is_expected.to have_selector :radio_button, 'jira-setupwizard-email-notifications-enabled' }
      it { is_expected.to have_selector :radio_button, 'jira-setupwizard-email-notifications-disabled' }
      it { is_expected.to have_button 'Finish' }
    end

    context 'when processing email notifications setup' do
      before :all do
        within '#jira-setupwizard' do
          choose 'jira-setupwizard-email-notifications-disabled'
          click_button 'Finish'
        end
      end

      it { is_expected.to have_current_path %r{/secure/Dashboard.jspa} }

      # The acceptance testing comes to an end here since we got to the
      # JIRA dashboard without any trouble through the setup.
    end
  end

  # describe 'Stopping the JIRA instance' do
  #   before(:all) { @container_jira.kill_and_wait signal: 'SIGTERM' }
  #
  #   subject { @container_jira }
  #
  #   it 'should shut down successful' do
  #     # give the container up to 5 minutes to successfully shutdown
  #     # exit code: 128+n Fatal error signal "n", ie. 143 = fatal error signal
  #     # SIGTERM
  #     #
  #     # The following state check has been left out 'ExitCode' => 143 to
  #     # suppor CircleCI as CI builder. For some reason whether you send SIGTERM
  #     # or SIGKILL, the exit code is always 0, perhaps it's the container
  #     # driver
  #     is_expected.to include_state 'Running' => false
  #   end
  #
  #   include_examples 'a clean console'
  #   include_examples 'a clean logfile', '/var/atlassian/jira/log/atlassian-jira.log'
  # end
end
