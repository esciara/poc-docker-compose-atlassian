shared_examples 'a clean confluence console' do
  context 'validating console output' do
    it { is_expected.to_not contain_console_output REGEX_SEVERE, filter: REGEX_FILTER_CONFLUENCE }
    it { is_expected.to_not contain_console_output REGEX_ERROR, filter: REGEX_FILTER_CONFLUENCE }
    # There happens a lot of warnings by default so disable this check for now
    # it { is_expected.to_not contain_console_output REGEX_WARN, filter: REGEX_FILTER_CONFLUENCE }
  end
end

shared_examples 'a clean jira console' do
  context 'validating console output' do
    it { is_expected.to_not contain_console_output REGEX_SEVERE, filter: REGEX_FILTER_JIRA }
    # it { is_expected.to_not contain_console_output REGEX_ERROR, filter: REGEX_FILTER_JIRA }
    # There happens a lot of warnings by default so disable this check for now
    # it { is_expected.to_not contain_console_output REGEX_WARN, filter: REGEX_FILTER_JIRA }
  end
end
