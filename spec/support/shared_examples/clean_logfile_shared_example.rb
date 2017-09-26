shared_examples 'a clean confluence logfile' do |log_file|
  context "validating logfile \"#{log_file}\"" do
    it { is_expected.to_not have_file_contain log_file, REGEX_SEVERE, filter: REGEX_FILTER_CONFLUENCE } unless ENV['CIRCLECI']
    it { is_expected.to_not have_file_contain log_file, REGEX_ERROR, filter: REGEX_FILTER_CONFLUENCE } unless ENV['CIRCLECI']
    # There happens a lot of warnings by default so disable this check for now
    # it { is_expected.to_not have_file_contain log_file, REGEX_WARN, filter: REGEX_FILTER_CONFLUENCE }
  end
end

shared_examples 'a clean jira logfile' do |log_file|
  context "validating logfile \"#{log_file}\"" do
    it { is_expected.to_not have_file_contain log_file, REGEX_SEVERE, filter: REGEX_FILTER_JIRA } unless ENV['CIRCLECI']
    it { is_expected.to_not have_file_contain log_file, REGEX_ERROR, filter: REGEX_FILTER_JIRA } unless ENV['CIRCLECI']
    # There happens a lot of warnings by default so disable this check for now
    # it { is_expected.to_not have_file_contain log_file, REGEX_WARN, filter: REGEX_FILTER_JIRA }
  end
end
