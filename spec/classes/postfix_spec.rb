require "#{File.join(File.dirname(__FILE__),'..','/..','/..','/spec_helper.rb')}"

describe 'postfix' do
  let(:title) { 'postfix' }
  let(:params) { {:package=>{'name'=>'postfix','ensure'=>'present'}} }

  it do
    should contain_class('postfix::package').with({
      'package' => 'postfix',
      'status'  => 'present',
    })
  end

  it do
    should contain_class('postfix::files').with({
      'relay'         => 'false',
      'relayhost'     => '',
      'local_mx'      => '',
      'smarthost'     => 'false',
      'relay_domains' => '[]',
      'status'        => 'present',
    })
  end

  it do
    should contain_class('postfix::service').with({
      'status'  => 'present',
    })
  end
  
end
