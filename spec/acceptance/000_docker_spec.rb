describe 'Docker validation' do
  context 'when validating host software' do
    it 'should supported version' do
      expect { Docker.validate_version! }.to_not raise_error
    end
  end
end
