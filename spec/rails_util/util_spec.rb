require 'spec_helper'

describe RailsUtil::Util do
  let(:path) { 'test.deep.path' }
  let(:value) { 'value' }
  let(:obj) { {} }
  let(:desired_result) do
    {
      'test' => {
        'deep' => {
          'path' => value
        }
      }
    }
  end

  describe 'self.set_nested' do
    let(:subject) { RailsUtil::Util.set_nested(path, value, obj) }

    it 'should return a nested hash with the correct keys' do
      expect(subject).to eq(desired_result)
    end
  end

  describe 'self.set_nested!' do
    let(:subject) { RailsUtil::Util.set_nested!(path, value, obj) }

    it 'should return a nested hash with the correct keys' do
      expect(subject).to eq(desired_result)
    end
  end

  describe 'self.path_to_hash' do
    let(:subject) { RailsUtil::Util.path_to_hash(path, value) }

    it 'should return a nested hash with the correct keys' do
      expect(subject).to eq(desired_result)
    end
  end
end
