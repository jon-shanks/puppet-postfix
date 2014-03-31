require "#{File.join(File.dirname(__FILE__),'..','/..','/..','/spec_helper.rb')}"

describe 'postfix::files' do
  let(:title) { 'postfix::files' }
  
  context 'if relay true and status present and mail relay details set' do
    let(:params) { {:relay => true, :status => "present"} }

    it { should contain_file('/etc/postfix/transport').with({'ensure'=>'present'}) }
    it { should contain_exec('/usr/sbin/postmap /etc/postfix/transport').with({'refreshonly'=>'true'}) }
    it { should contain_file('/etc/aliases').with({'ensure'=>'present'}) }
    it { should contain_exec('/usr/bin/newaliases').with({'refreshonly'=>'true','subscribe'=>'File[/etc/aliases]'}) }

  end

  context 'if relay true test the transport content' do
    let(:params) { {:relay => "true", :status => "present", :relay_domains => ["nyx.com", "cmi2.nyx.com"], :local_mx => ["bas-h5-cmi-mailrelay.europe.nyx.com"]} }

    it 'should generate content' do
      content = catalogue.resource('file', '/etc/postfix/transport').send(:parameters)[:content]
      content.should_not be_empty
      content.should match("nyx.com")
      content.should match("bas-h5-cmi-mailrelay.europe.nyx.com")
    end
  end

  context 'if relay true and aliases set' do
    let(:params) { {:relay => "true", :status => "present", :root_email => "jshanks@nyx.com"} }
  
    it 'should generate aliases with root email' do
      content = catalogue.resource('file', '/etc/aliases').send(:parameters)[:content]
      content.should_not be_empty
      content.should match("jshanks@nyx.com")
    end
  end

  context 'if smart host is set' do
    let(:params) { {:relay => "true", :status => "present", :smarthost => '["bas-h5-cmi-mailrelay.europe.nyx.com"]'} }

    it 'should generate transport with smarthost' do
      content = catalogue.resource('file', '/etc/postfix/transport').send(:parameters)[:content]
      content.should_not be_empty
      content.should match("bas-h5-cmi-mailrelay.europe.nyx.com")
    end
  end
  
  context 'when relay_host is just set and defaults' do
    let(:params) { {:status => 'present', :relayhost => 'bas-h5-cmi-mailrelay.europe.nyx.com'} }
  
    it { should contain_file('/etc/postfix/transport').with({'ensure'=>'absent'}) }
    it { should_not contain_exec('/usr/sbin/postmap /etc/postfix/transport') }
    it { should contain_file('/etc/aliases').with({'ensure'=>'absent'}) }
    it { should_not contain_exec('/usr/bin/newaliases') }

    it { should contain_file('/etc/postfix/main.cf').with({'ensure'=>'present'}) }
    
    it 'should have standard postfix main.cf' do
      content = catalogue.resource('file', '/etc/postfix/main.cf').send(:parameters)[:content]
      content.should_not be_empty
      content.should match("bas-h5-cmi-mailrelay.europe.nyx.com")
    end
  end

  context 'when it is a relay server the main.cf settings will be' do
    let(:params) { {:status => 'present', :relay => 'true', :mynetworks => ["10.189.0.1"], :relay_domains => ["nyx.com"]} }
    it 'should generate postfix main' do
      content = catalogue.resource('file', '/etc/postfix/main.cf').send(:parameters)[:content]
      content.should_not be_empty
      content.should match("all")
      content.should match("nyx.com")
      content.should match("10.189.0.1")
      content.should_not match("relayhost")
    end
  end

  context 'when status is absent and relay true' do
    let(:params) { {:status => 'absent', :relay => 'true'} }

    it { should contain_file('/etc/postfix/transport').with({'ensure' => 'absent'}) }
    it { should contain_file('/etc/aliases').with({'ensure' => 'absent'}) }

  end

  context 'when status is absent and relay true' do
    let(:params) { {:status => 'absent'} }

    ['/etc/postfix/transport', '/etc/aliases', '/etc/postfix/main.cf'].each do |f| 
      it do should contain_file(f).with({'ensure' => 'absent'}) end
    end
  end
end
