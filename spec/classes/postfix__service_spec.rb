require "#{File.join(File.dirname(__FILE__),'..','/..','/..','/spec_helper.rb')}"

describe 'postfix::service' do
  let(:title) { 'postfix::service' } 

  context 'when status is present' do
    let(:params) { {:status => 'present'} }
    it do
      should contain_service('postfix').with({
        'ensure'=>'running'
      })
    end
  end

  context 'when status is absent' do
    let(:params) { {:status => 'absent'} }
    it do
      should contain_service('postfix').with({
        'ensure'=>'stopped'
      })
    end
  end

end
