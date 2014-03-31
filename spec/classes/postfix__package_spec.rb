require "#{File.join(File.dirname(__FILE__),'..','/..','/..','/spec_helper.rb')}"

describe 'postfix::package' do
  let(:title) { 'postfix::package' }
  let(:params) { {:package=>'postfix', :status=>'present'} }

  it do
    should contain_package('postfix').with({
      'ensure'  => 'present'
    })
  end

end
