# Does not work for up to 6.3.X
# This needs to be probably fourther corrected to work for >= 6.4.0
shared_examples 'using a confluence embedded database' do
  before :all do
    # This is for up to 6.3.X
    # within 'form[name=embeddedform]' do
    #   click_button 'Embedded Database'
    # end
    # This is for >= 6.4.0
    within 'form[name=setupdbchoice]' do
      find(:css, 'div.select-database-choice-box[data-database-choice=embedded]').trigger('click')
      click_button 'Next'
      wait_for_page
    end
  end

  it { is_expected.to have_current_path %r{/setup/setupdata-start.action} }
  it { is_expected.to have_css 'form#demoChoiceForm' }
  it { is_expected.to have_button 'Example Site' }
end

shared_examples 'using a jira embedded database' do
	before :all do
		within 'form#jira-setup-database' do
			choose 'jira-setup-database-field-database-internal'
			click_button 'Next'
		end
	end
end
