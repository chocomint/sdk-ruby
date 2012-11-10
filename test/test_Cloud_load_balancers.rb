# coding:utf-8
#--
# ニフティクラウドSDK for Ruby
#
# Ruby Gem Name::  nifty-cloud-sdk
# Author::    NIFTY Corporation
# Copyright:: Copyright 2011 NIFTY Corporation All Rights Reserved.
# License::   Distributes under the same terms as Ruby
# Home::      http://cloud.nifty.com/api/
#++

require File.dirname(__FILE__) + '/test_helper.rb'

context "load_balancers" do
  before do
    @api = NIFTY::Cloud::Base.new( :access_key_id => "not a key", :secret_access_key => "not a secret",  
                                     :server => 'cp.cloud.nifty.com', :path => '/api/1.7/', :user_agent => 'NIFTY Cloud API Ruby SDK',
                                     :signature_version => '2', :signature_method => 'HmacSHA256')

    @valid_protocol = %w(HTTP HTTPS FTP)
    @valid_port     = [443, 80, 21, '443', '80', '21']
    @valid_balancing_type = [1, 2, '1', '2']
    @valid_network_volume = [10, 20, 30, 40, 100, 200, '10', '20', '30', '40', '100', '200']
    @valid_ip_version = %w(v4 v6)

    @basic_create_lb_params = {
      :load_balancer_name => 'lb01',
      :listeners => [{:protocol => 'HTTP', :instance_port => '80'}]
    }
    @basic_reg_instance_params = {
      :load_balancer_name => 'lb1', :load_balancer_port => 80, :instance_port => 80, 
      :instances => 'server01'
    }
    @basic_dereg_instance_params = @basic_reg_instance_params
    @basic_desc_instance_health_params = {:load_balancer_name => 'lb1', :load_balancer_port => 80, :instance_port => 80}
    @basic_conf_health_params = {
      :load_balancer_name => 'lb1', :load_balancer_port => 80, :instance_port => 80, :target => 'TCP:80', :interval => 30,
      :unhealthy_threshold => 1
    }
    @basic_set_filter_params = {:load_balancer_name => 'lb1', :load_balancer_port => 80, :instance_port => 80}

    @valid_delete_load_balancer_params = {
      :load_balancer_name => 'Test Name'
    }

    @valid_describe_load_balancer_params = {
    }

    @valid_register_instances_with_load_balancer_params = {
      :load_balancer_name => 'Test Name',
      :instances => ['i-6055fa09']
    }

    @valid_deregister_instances_from_load_balancer_params = @valid_register_instances_with_load_balancer_params

    @valid_configure_health_check_params = {
      :load_balancer_name => 'Test Name',
      :health_check => {
      :target   => 'HTTP:80/servlets-examples/servlet/',
      :timeout  => '2',
      :interval => '5',
      :unhealthy_threshold => '2',
      :healthy_threshold   =>  '2'}
    }

    @create_load_balancer_response_body = <<-RESPONSE
    <CreateLoadBalancerResponse xmlns="https://cp.cloud.nifty.com/api/1.5/">      
      <CreateLoadBalancerResult>    
        <DNSName>10.0.5.222</DNSName>  
      </CreateLoadBalancerResult>    
      <ResponseMetadata>    
        <RequestId>f6dd8353-eb6b-6b4fd32e4f05</RequestId>  
      </ResponseMetadata>    
    </CreateLoadBalancerResponse>      
    RESPONSE
    
    @update_load_balancer_response_body = <<-RESPONSE
    <UpdateLoadBalancerResponse xmlns="https://cp.cloud.nifty.com/api/1.5/">      
      <ResponseMetadata>    
        <RequestId>f6dd8353-eb6b-6b4fd32e4f05</RequestId>  
      </ResponseMetadata>    
    </UpdateLoadBalancerResponse>      
    RESPONSE

    @delete_load_balancer_response_body = <<-RESPONSE
    <DeleteLoadBalancerResponse xmlns="https://cp.cloud.nifty.com/api/1.5/">      
      <DeleteLoadBalancerResult />    
      <ResponseMetadata>    
          <RequestId>f6dd8353-eb6b-6b4fd32e4f05</RequestId>
      </ResponseMetadata>    
    </DeleteLoadBalancerResponse>      
    RESPONSE

    @describe_load_balancers_response_body = <<-RESPONSE
    <DescribeLoadBalancersResponse xmlns="https://cp.cloud.nifty.com/api/1.5/">              
      <DescribeLoadBalancersResult>            
        <LoadBalancerDescriptions>          
          <member>        
            <LoadBalancerName>lb0001</LoadBalancerName>      
            <DNSName>10.0.5.222</DNSName>      
            <NetworkVolume>10</NetworkVolume>      
            <ListenerDescriptions>      
              <member>    
                <Listener>  
                  <Protocol>http</Protocol>
                  <LoadBalancerPort>80</LoadBalancerPort>
                  <InstancePort>80</InstancePort>
                  <balancingType>1</balancingType>
                </Listener>  
              </member>    
            </ListenerDescriptions>      
            <Instances>      
              <member>    
                <InstanceId>server02</InstanceId>  
                <InstanceId>server03</InstanceId>
              </member>  
            </Instances>    
            <HealthCheck>    
              <Target>TCP:80</Target>  
              <Interval>300</Interval>  
              <Timeout>30</Timeout>  
              <UnhealthyThreshold>1</UnhealthyThreshold>  
              <HealthyThreshold>1</HealthyThreshold>  
            </HealthCheck>    
            <Filter>    
              <FilterType>1</FilterType>  
              <IPAddresses>  
                <member>111.111.111.111</member>
                <member>111.111.111.112</member>
              </IPAddresses>  
            </Filter>    
            <AvailabilityZones>    
              <member>ap-japan-1a</member>  
            </AvailabilityZones>    
            <CreatedTime>2010-05-17T11:22:33.456Z</CreatedTime>    
          </member>      
        </LoadBalancerDescriptions>        
        <LoadBalancerDescriptions>        
          <member>      
            <LoadBalancerName>lb0001</LoadBalancerName>    
            <DNSName>10.0.5.222</DNSName>    
            <NetworkVolume>10</NetworkVolume>    
            <ListenerDescriptions>    
              <member>  
                <Protocol>http</Protocol>
                <LoadBalancerPort>443</LoadBalancerPort>
                <InstancePort>443</InstancePort>
                <balancingType>2</balancingType>
              </member>  
            </ListenerDescriptions>    
            <Instances>    
              <member>  
                <InstanceId>server02</InstanceId>
                <InstanceId>server03</InstanceId>
              </member>  
            </Instances>    
            <HealthCheck>    
              <Target>TCP:443</Target>  
              <Interval>300</Interval>  
              <Timeout>30</Timeout>  
              <UnhealthyThreshold>1</UnhealthyThreshold>  
              <HealthyThreshold>1</HealthyThreshold>  
            </HealthCheck>    
            <Filter>    
              <FilterType>1</FilterType>  
              <IPAddresses>  
                <member>*.*.*.*</member>
              </IPAddresses>  
            </Filter>    
            <AvailabilityZones>    
              <member>ap-japan-1a</member>  
            </AvailabilityZones>    
            <CreatedTime>2010-05-17T11:22:43.789Z</CreatedTime>    
          </member>      
        </LoadBalancerDescriptions>        
      </DescribeLoadBalancersResult>          
      <ResponseMetadata>          
        <RequestId>f6dd8353-eb6b-6b4fd32e4f05</RequestId>        
      </ResponseMetadata>            
    </DescribeLoadBalancersResponse>              
    RESPONSE
    
    @register_port_with_load_balancer_response_body = <<-RESPONSE
    <RegisterPortWithLoadBalancerResponse xmlns="https://cp.cloud.nifty.com/api/1.5/">          
      <RegisterPortWithLoadBalancerResult>        
        <ListenerDescriptions>      
          <member>    
            <Listener>  
              <Protocol>http</Protocol>
              <LoadBalancerPort>80</LoadBalancerPort>
              <InstancePort>80</InstancePort>
              <balancingType>1</balancingType>
            </Listener>  
          </member>    
          <member>    
            <Listener>  
              <Protocol>https</Protocol>
              <LoadBalancerPort>443</LoadBalancerPort>
              <InstancePort>443</InstancePort>
              <balancingType>1</balancingType>
            </Listener>  
          </member>    
        </ListenerDescriptions>      
      </RegisterPortWithLoadBalancerResult>        
      <ResponseMetadata>        
            <RequestId>f6dd8353-eb6b-6b4fd32e4f05</RequestId>  
      </ResponseMetadata>        
    </RegisterPortWithLoadBalancerResponse>          
    RESPONSE

    @register_instances_with_load_balancer_response_body = <<-RESPONSE
    <RegisterInstancesWithLoadBalancerResponse xmlns="https://cp.cloud.nifty.com/api/1.5/">        
      <RegisterInstancesWithLoadBalancerResult>      
        <Instances>    
          <member>  
            <InstanceId>server02</InstanceId>
          </member>  
        </Instances>    
      </RegisterInstancesWithLoadBalancerResult>      
      <ResponseMetadata>      
        <RequestId>f6dd8353-eb6b-6b4fd32e4f05</RequestId>    
      </ResponseMetadata>      
    </RegisterInstancesWithLoadBalancerResponse>        
    RESPONSE

    @deregister_instances_from_load_balancer_response_body = <<-RESPONSE
    <DeregisterInstancesFromLoadBalancerResponse xmlns="https://cp.cloud.nifty.com/api/1.5/">        
      <DeregisterInstancesFromLoadBalancerResult>      
        <Instances>    
          <member>  
            <InstanceId>server03</InstanceId>
          </member>  
        </Instances>    
      </DeregisterInstancesFromLoadBalancerResult>      
      <ResponseMetadata>      
        <RequestId>f6dd8353-eb6b-6b4fd32e4f05</RequestId>    
      </ResponseMetadata>      
    </DeregisterInstancesFromLoadBalancerResponse>        
    RESPONSE

    @describe_instance_health_response_body = <<-RESPONSE
    <DescribeInstanceHealthResponse xmlns="https://cp.cloud.nifty.com/api/1.5/">        
      <DescribeInstanceHealthResult>      
        <InstanceStates>    
          <member>  
            <InstanceId>server02</InstanceId>
            <State>InService</State>
            <ReasonCode>N/A</ReasonCode>
            <Description>N/A</Description>
          </member>  
          <member>  
          <InstanceId>server06</InstanceId>  
            <State>OutOfService</State>
            <ReasonCode>ELB</ReasonCode>
            <Description>Instance registration is still in progress</Description>
          </member>  
        </InstanceStates>    
      </DescribeInstanceHealthResult>      
      <ResponseMetadata>      
        <RequestId>f6dd8353-eb6b-6b4fd32e4f05</RequestId>    
      </ResponseMetadata>      
    </DescribeInstanceHealthResponse>        
    RESPONSE

    @configure_health_check_response_body = <<-RESPONSE
    <ConfigureHealthCheckResponse xmlns="https://cp.cloud.nifty.com/api/1.5/">      
      <ConfigureHealthCheckResult>    
        <HealthCheck>  
          <Target>TCP:80</Target>
          <Interval>300</Interval>
          <Timeout>30</Timeout>  
          <UnhealthyThreshold>3</UnhealthyThreshold>  
          <HealthyThreshold>1</HealthyThreshold>  
        </HealthCheck>    
      </ConfigureHealthCheckResult>      
      <ResponseMetadata>      
        <RequestId>f6dd8353-eb6b-6b4fd32e4f05</RequestId>    
      </ResponseMetadata>      
    </ConfigureHealthCheckResponse>        
    RESPONSE

    @set_filter_for_load_balancer_response_body = <<-RESPONSE
    <SetFilterForLoadBalancerResponse xmlns="https://cp.cloud.nifty.com/api/1.5/">        
      <SetFilterForLoadBalancerResult>      
        <Filter>    
          <FilterType>1</FilterType>  
          <IPAddresses>  
            <member>111.111.111.111</member>
            <member>111.111.111.112</member>  
          </IPAddresses>    
        </Filter>      
      </SetFilterForLoadBalancerResult>        
      <ResponseMetadata>        
        <RequestId>f6dd8353-eb6b-6b4fd32e4f05</RequestId>      
      </ResponseMetadata>        
    </SetFilterForLoadBalancerResponse>          
    RESPONSE
  end


  # create_load_balancer
  specify "create_load_balancer - レスポンスを正しく解析できるか" do
    @api.stubs(:exec_request).returns stub(:body => @create_load_balancer_response_body, :is_a? => true)
    response = @api.create_load_balancer(:load_balancer_name => 'lb1', :listeners => {:protocol => 'HTTPS', :instance_port => 443})
    response.CreateLoadBalancerResult.DNSName.should.equal '10.0.5.222'
    response.ResponseMetadata.RequestId.should.equal 'f6dd8353-eb6b-6b4fd32e4f05'
  end

  specify "create_load_balancer - パラメータが正しく作られるか" do
    @api.stubs(:make_request).with("Action" => "CreateLoadBalancer",
                                   "LoadBalancerName" => "a",
                                   "Listeners.member.1.Protocol" => "HTTP",
                                   "Listeners.member.2.Protocol" => "HTTP",
                                   "Listeners.member.1.LoadBalancerPort" => "80",
                                   "Listeners.member.2.LoadBalancerPort" => "80",
                                   "Listeners.member.1.InstancePort" => "80",
                                   "Listeners.member.2.InstancePort" => "80",
                                   "Listeners.member.1.BalancingType" => "1",
                                   "Listeners.member.2.BalancingType" => "1",
                                   "AvailabilityZones.member.1" => "a",
                                   "AvailabilityZones.member.2" => "a",
                                   "NetworkVolume" => "10",
                                   "IpVersion" => "v4"
                                  ).returns stub(:body => @create_load_balancer_response_body, :is_a? => true)
    @api.stubs(:exec_request).returns stub(:body => @create_load_balancer_response_body, :is_a? => true)
    response = @api.create_load_balancer(:load_balancer_name => "a", :listeners => [{:protocol => "HTTP", :load_balancer_port => 80, :instance_port => 80, :balancing_type => 1},{:protocol => "HTTP", :load_balancer_port => 80, :instance_port => 80, :balancing_type => 1}], :availability_zones => %w(a a), :network_volume => 10, :ip_version => "v4")
  end

  specify "create_load_balancer - :listeners - :protocol正常" do
    @api.stubs(:exec_request).returns stub(:body => @create_load_balancer_response_body, :is_a? => true)
    @valid_protocol.each do |protocol|
      lambda { @api.create_load_balancer(:load_balancer_name => 'lb1', :listeners => {:protocol => protocol, :instance_port => 80}) }.should.not.raise(NIFTY::ArgumentError)
    end
  end
  
  specify "create_load_balancer - :listeners - :load_balancer_port正常" do
    @api.stubs(:exec_request).returns stub(:body => @create_load_balancer_response_body, :is_a? => true)
    @valid_port.each do |port|
      lambda { @api.create_load_balancer(:load_balancer_name => 'lb1', :listeners => {:load_balancer_port => port, :instance_port => 80}) }.should.not.raise(NIFTY::ArgumentError)
    end
  end
  
  specify "create_load_balancer - :listeners - :instance_port正常" do
    @api.stubs(:exec_request).returns stub(:body => @create_load_balancer_response_body, :is_a? => true)
    @valid_port.each do |port|
      lambda { @api.create_load_balancer(:load_balancer_name => 'lb1', :listeners => {:protocol => 'HTTP', :instance_port => port}) }.should.not.raise(NIFTY::ArgumentError)
    end
  end
  
  specify "create_load_balancer - :listeners - :balancing_type正常" do
    @api.stubs(:exec_request).returns stub(:body => @create_load_balancer_response_body, :is_a? => true)
    @valid_balancing_type.each do |type|
      lambda { @api.create_load_balancer(:load_balancer_name => 'lb1', :listeners => {:balancing_type => type, :protocol => 'HTTP', :instance_port => 80}) }.should.not.raise(NIFTY::ArgumentError)
    end
  end
  
  specify "create_load_balancer - :network_volume正常" do
    @api.stubs(:exec_request).returns stub(:body => @create_load_balancer_response_body, :is_a? => true)
    @valid_network_volume.each do |vol|
      lambda { @api.create_load_balancer(@basic_create_lb_params.merge(:network_volume => vol)) }.should.not.raise(NIFTY::ArgumentError)
    end
  end
  
  specify "create_load_balancer - :ip_version正常" do
    @api.stubs(:exec_request).returns stub(:body => @create_load_balancer_response_body, :is_a? => true)
    @valid_ip_version.each do |ver|
      lambda { @api.create_load_balancer(@basic_create_lb_params.merge(:ip_version => ver)) }.should.not.raise(NIFTY::ArgumentError)
    end
  end
  
  specify "create_load_balancer - :load_balancer_name未指定" do
    lambda { @api.create_load_balancer }.should.raise(NIFTY::ArgumentError)
    lambda { @api.create_load_balancer(:load_balancer_name => nil) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.create_load_balancer(:load_balancer_name => '') }.should.raise(NIFTY::ArgumentError)
  end

  specify "create_load_balancer - :listeners未指定" do
    lambda { @api.create_load_balancer(:load_balancer_name => 'lb1') }.should.raise(NIFTY::ArgumentError)
    lambda { @api.create_load_balancer(:load_balancer_name => 'lb1', :listeners => nil) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.create_load_balancer(:load_balancer_name => 'lb1', :listeners => '') }.should.raise(NIFTY::ArgumentError)
  end

  specify "create_load_balancer - :listeners - :protocol, :load_balancer_port未指定/不正" do
    lambda { @api.create_load_balancer(:load_balancer_name => 'lb1', :listeners => {:instance_port => 80}) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.create_load_balancer(:load_balancer_name => 'lb1', :listeners => {:instance_port => 80, :protocol => nil}) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.create_load_balancer(:load_balancer_name => 'lb1', :listeners => {:instance_port => 80, :protocol => ''}) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.create_load_balancer(:load_balancer_name => 'lb1', :listeners => {:instance_port => 80, :protocol => 'foo'}) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.create_load_balancer(:load_balancer_name => 'lb1', :listeners => {:instance_port => 80, :protocol => 'SSH'}) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.create_load_balancer(:load_balancer_name => 'lb1', :listeners => {:instance_port => 80, :load_balancer_port => 'foo'}) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.create_load_balancer(:load_balancer_name => 'lb1', :listeners => {:instance_port => 80, :load_balancer_port => 65536}) }.should.raise(NIFTY::ArgumentError)
  end

  specify "create_load_balancer - :listeners - :balancing_type不正" do
    lambda { @api.create_load_balancer(:load_balancer_name => 'lb1', :listeners => {:instance_port => 80, :protocol => 'HTTP', :balancing_type => 'foo'}) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.create_load_balancer(:load_balancer_name => 'lb1', :listeners => {:instance_port => 80, :protocol => 'HTTP', :balancing_type => 3}) }.should.raise(NIFTY::ArgumentError)
  end

  specify "create_load_balancer - :network_volume未指定" do
    lambda { @api.create_load_balancer(@basic_create_lb_params.merge(:network_volume => 'foo')) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.create_load_balancer(@basic_create_lb_params.merge(:network_volume => 500)) }.should.raise(NIFTY::ArgumentError)
  end

  specify "create_load_balancer - :ip_version未指定" do
    lambda { @api.create_load_balancer(@basic_create_lb_params.merge(:ip_version => 'foo')) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.create_load_balancer(@basic_create_lb_params.merge(:ip_version => 'v5')) }.should.raise(NIFTY::ArgumentError)
  end


  # update_load_balancer
  specify "update_load_balancer - レスポンスを正しく解析できるか" do
    @api.stubs(:exec_request).returns stub(:body => @update_load_balancer_response_body, :is_a? => true)
    response = @api.update_load_balancer(:load_balancer_name => 'lb1')
    response.ResponseMetadata.RequestId.should.equal 'f6dd8353-eb6b-6b4fd32e4f05'
  end

  specify "update_load_balancer - パラメータが正しく作られるか" do
    @api.stubs(:make_request).with("Action" => "UpdateLoadBalancer",
                                   "LoadBalancerName" => "a",
                                   "ListenerUpdate.LoadBalancerPort" => "80",
                                   "ListenerUpdate.InstancePort" => "80",
                                   "ListenerUpdate.Listener.Protocol" => "HTTP",
                                   "ListenerUpdate.Listener.LoadBalancerPort" => "80",
                                   "ListenerUpdate.Listener.InstancePort" => "80",
                                   "ListenerUpdate.Listener.BalancingType" => "1",
                                   "NetworkVolumeUpdate" => "10"
                                  ).returns stub(:body => @update_load_balancer_response_body, :is_a? => true)
    @api.stubs(:exec_request).returns stub(:body => @update_load_balancer_response_body, :is_a? => true)
    response = @api.update_load_balancer(:load_balancer_name => "a", :load_balancer_port => 80, :instance_port => 80, :listener_protocol => "HTTP", :listener_load_balancer_port => 80, :listener_instance_port => 80, :listener_balancing_type => 1, :network_volume_update => 10)
  end

  specify "update_load_balancer - :load_balancer_port正常" do
    @api.stubs(:exec_request).returns stub(:body => @update_load_balancer_response_body, :is_a? => true)
    @valid_port.each do |port|
      lambda { @api.update_load_balancer(:load_balancer_name => 'lb1', :load_balancer_port => port, :instance_port => 80) }.should.not.raise(NIFTY::ArgumentError)
    end
  end

  specify "update_load_balancer - :instance_port正常" do
    @api.stubs(:exec_request).returns stub(:body => @update_load_balancer_response_body, :is_a? => true)
    @valid_port.each do |port|
      lambda { @api.update_load_balancer(:load_balancer_name => 'lb1', :load_balancer_port => 80, :instance_port => port) }.should.not.raise(NIFTY::ArgumentError)
    end
  end
  
  specify "update_load_balancer - :protocol正常" do
    @api.stubs(:exec_request).returns stub(:body => @update_load_balancer_response_body, :is_a? => true)
    @valid_protocol.each do |protocol|
      lambda { @api.update_load_balancer(:load_balancer_name => 'lb1', :load_balancer_port => 80, :instance_port => 80, :listener_protocol => protocol) }.should.not.raise(NIFTY::ArgumentError)
    end
  end
  
  specify "update_load_balancer - :listener_load_balancer_port正常" do
    @api.stubs(:exec_request).returns stub(:body => @update_load_balancer_response_body, :is_a? => true)
    @valid_port.each do |port|
      lambda { @api.update_load_balancer(:load_balancer_name => 'lb1', :load_balancer_port => 80, :instance_port => 80, :listener_load_balancer_port => port) }.should.not.raise(NIFTY::ArgumentError)
    end
  end
  
  specify "update_load_balancer - :listener_instance_port正常" do
    @api.stubs(:exec_request).returns stub(:body => @update_load_balancer_response_body, :is_a? => true)
    @valid_port.each do |port|
      lambda { @api.update_load_balancer(:load_balancer_name => 'lb1', :load_balancer_port => 80, :instance_port => 80, :listener_instance_port => port) }.should.not.raise(NIFTY::ArgumentError)
    end
  end
  
  specify "update_load_balancer - :listener_balancing_type正常" do
    @api.stubs(:exec_request).returns stub(:body => @update_load_balancer_response_body, :is_a? => true)
    @valid_balancing_type.each do |type|
      lambda { @api.update_load_balancer(:load_balancer_name => 'lb1', :load_balancer_port => 80, :instance_port => 80, :listener_balancing_type => type) }.should.not.raise(NIFTY::ArgumentError)
    end
  end
  
  specify "update_load_balancer - :network_volume_update正常" do
    @api.stubs(:exec_request).returns stub(:body => @update_load_balancer_response_body, :is_a? => true)
    @valid_network_volume.each do |vol|
      lambda { @api.update_load_balancer(:load_balancer_name => 'lb1', :network_volume_update => vol) }.should.not.raise(NIFTY::ArgumentError)
    end
  end
  
  specify "update_load_balancer - :load_balancer_name未指定" do
    lambda { @api.update_load_balancer }.should.raise(NIFTY::ArgumentError)
    lambda { @api.update_load_balancer(:load_balancer_name => nil) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.update_load_balancer(:load_balancer_name => '') }.should.raise(NIFTY::ArgumentError)
  end

  specify "update_load_balancer - :load_balancer_port未指定/不正" do
    lambda { @api.update_load_balancer(:load_balancer_name => 'lb1', :listener_protocol => 'HTTP') }.should.raise(NIFTY::ArgumentError)
    lambda { @api.update_load_balancer(:load_balancer_name => 'lb1', :load_balancer_port => nil, :listener_protocol => 'HTTP') }.should.raise(NIFTY::ArgumentError)
    lambda { @api.update_load_balancer(:load_balancer_name => 'lb1', :load_balancer_port => '', :listener_protocol => 'HTTP') }.should.raise(NIFTY::ArgumentError)
    lambda { @api.update_load_balancer(:load_balancer_name => 'lb1', :load_balancer_port => 65536) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.update_load_balancer(:load_balancer_name => 'lb1', :load_balancer_port => 'foo') }.should.raise(NIFTY::ArgumentError)
  end

  specify "update_load_balancer - :instance_port不正" do
    lambda { @api.update_load_balancer(:load_balancer_name => 'lb1', :load_balancer_port => 80, :listener_protocol => 'HTTP') }.should.raise(NIFTY::ArgumentError)
    lambda { @api.update_load_balancer(:load_balancer_name => 'lb1', :load_balancer_port => 80, :instance_port => nil, :listener_protocol => 'HTTP') }.should.raise(NIFTY::ArgumentError)
    lambda { @api.update_load_balancer(:load_balancer_name => 'lb1', :load_balancer_port => 80, :instance_port => '', :listener_protocol => 'HTTP') }.should.raise(NIFTY::ArgumentError)
    lambda { @api.update_load_balancer(:load_balancer_name => 'lb1', :instance_port => 65536) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.update_load_balancer(:load_balancer_name => 'lb1', :instance_port => 'foo') }.should.raise(NIFTY::ArgumentError)
  end

  specify "update_load_balancer - :listener_protocol不正" do
    lambda { @api.update_load_balancer(:load_balancer_name => 'lb1', :listener_protocol => 'ABC') }.should.raise(NIFTY::ArgumentError)
    lambda { @api.update_load_balancer(:load_balancer_name => 'lb1', :listener_protocol => 80) }.should.raise(NIFTY::ArgumentError)
  end

  specify "update_load_balancer - :listener_load_balancer_port不正" do
    lambda { @api.update_load_balancer(:load_balancer_name => 'lb1', :listener_load_balancer_port => 65536) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.update_load_balancer(:load_balancer_name => 'lb1', :listener_load_balancer_port => 'foo') }.should.raise(NIFTY::ArgumentError)
  end

  specify "update_load_balancer - :listener_instance_port不正" do
    lambda { @api.update_load_balancer(:load_balancer_name => 'lb1', :listener_instance_port => 65536) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.update_load_balancer(:load_balancer_name => 'lb1', :listener_instance_port => 'foo') }.should.raise(NIFTY::ArgumentError)
  end

  specify "update_load_balancer - :listener_balancing_type不正" do
    lambda { @api.update_load_balancer(:load_balancer_name => 'lb1', :listener_balancing_type => 3) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.update_load_balancer(:load_balancer_name => 'lb1', :listener_balancing_type => 'foo') }.should.raise(NIFTY::ArgumentError)
  end

  specify "update_load_balancer - :network_volume_update不正" do
    lambda { @api.update_load_balancer(:load_balancer_name => 'lb1', :network_volume_update => 300) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.update_load_balancer(:load_balancer_name => 'lb1', :network_volume_update => 'foo') }.should.raise(NIFTY::ArgumentError)
  end


  # delete_load_balancer
  specify "delete_load_balancer - レスポンスを正しく解析できるか" do
    @api.stubs(:exec_request).returns stub(:body => @delete_load_balancer_response_body, :is_a? => true)
    response = @api.delete_load_balancer(:load_balancer_name => 'lb1', :load_balancer_port => 443, :instance_port => 443)
    response.DeleteLoadBalancerResult.should.equal nil
    response.ResponseMetadata.RequestId.should.equal 'f6dd8353-eb6b-6b4fd32e4f05'
  end

  specify "delete_load_balancer - パラメータが正しく作られるか" do
    @api.stubs(:make_request).with("Action" => "DeleteLoadBalancer",
                                   "LoadBalancerName" => "a",
                                   "LoadBalancerPort" => "80",
                                   "InstancePort" => "80"
                                  ).returns stub(:body => @delete_load_balancer_response_body, :is_a? => true)
    @api.stubs(:exec_request).returns stub(:body => @delete_load_balancer_response_body, :is_a? => true)
    response = @api.delete_load_balancer(:load_balancer_name => "a", :load_balancer_port => 80, :instance_port => 80)
  end

  specify "delete_load_balancer - :load_balancer_port正常" do
    @api.stubs(:exec_request).returns stub(:body => @delete_load_balancer_response_body, :is_a? => true)
    @valid_port.each do |port|
      lambda { @api.delete_load_balancer(:load_balancer_name => 'lb1', :load_balancer_port => port, :instance_port => 80) }.should.not.raise(NIFTY::ArgumentError)
    end
  end

  specify "delete_load_balancer - :instance_port正常" do
    @api.stubs(:exec_request).returns stub(:body => @delete_load_balancer_response_body, :is_a? => true)
    @valid_port.each do |port|
      lambda { @api.delete_load_balancer(:load_balancer_name => 'lb1', :load_balancer_port => 80, :instance_port => port) }.should.not.raise(NIFTY::ArgumentError)
    end
  end

  specify "delete_load_balancer - :load_balancer_name未指定" do
    lambda { @api.delete_load_balancer }.should.raise(NIFTY::ArgumentError)
    lambda { @api.delete_load_balancer(:load_balancer_name => nil) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.delete_load_balancer(:load_balancer_name => '') }.should.raise(NIFTY::ArgumentError)
  end

  specify "delete_load_balancer - :load_balancer_port未指定/不正" do
    lambda { @api.delete_load_balancer(:load_balancer_name => 'lb1') }.should.raise(NIFTY::ArgumentError)
    lambda { @api.delete_load_balancer(:load_balancer_name => 'lb1', :load_balancer_port => 65536) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.delete_load_balancer(:load_balancer_name => 'lb1', :load_balancer_port => 'foo') }.should.raise(NIFTY::ArgumentError)
  end

  specify "delete_load_balancer - :instance_port未指定/不正" do
    lambda { @api.delete_load_balancer(:load_balancer_name => 'lb1') }.should.raise(NIFTY::ArgumentError)
    lambda { @api.delete_load_balancer(:load_balancer_name => 'lb1', :instance_port => -1) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.delete_load_balancer(:load_balancer_name => 'lb1', :instance_port => 'foo') }.should.raise(NIFTY::ArgumentError)
  end


  # describe_load_balancers
  specify "describe_load_balancers - レスポンスを正しく解析できるか" do
    @api.stubs(:exec_request).returns stub(:body => @describe_load_balancers_response_body, :is_a? => true)
    response = @api.describe_load_balancers
    response.DescribeLoadBalancersResult.LoadBalancerDescriptions[0].member[0].LoadBalancerName.should.equal 'lb0001'
    response.DescribeLoadBalancersResult.LoadBalancerDescriptions[0].member[0].DNSName.should.equal '10.0.5.222'
    response.DescribeLoadBalancersResult.LoadBalancerDescriptions[0].member[0].NetworkVolume.should.equal '10'
    response.DescribeLoadBalancersResult.LoadBalancerDescriptions[0].member[0].ListenerDescriptions.member[0].Listener.Protocol.should.equal 'http'
    response.DescribeLoadBalancersResult.LoadBalancerDescriptions[0].member[0].ListenerDescriptions.member[0].Listener.LoadBalancerPort.should.equal '80'
    response.DescribeLoadBalancersResult.LoadBalancerDescriptions[0].member[0].ListenerDescriptions.member[0].Listener.InstancePort.should.equal '80'
    response.DescribeLoadBalancersResult.LoadBalancerDescriptions[0].member[0].ListenerDescriptions.member[0].Listener.balancingType.should.equal '1'
    response.DescribeLoadBalancersResult.LoadBalancerDescriptions[0].member[0].Instances.member[0].InstanceId[0].should.equal 'server02'
    response.DescribeLoadBalancersResult.LoadBalancerDescriptions[0].member[0].Instances.member[0].InstanceId[1].should.equal 'server03'
    response.DescribeLoadBalancersResult.LoadBalancerDescriptions[0].member[0].HealthCheck.Target.should.equal 'TCP:80'
    response.DescribeLoadBalancersResult.LoadBalancerDescriptions[0].member[0].HealthCheck.Interval.should.equal '300'
    response.DescribeLoadBalancersResult.LoadBalancerDescriptions[0].member[0].HealthCheck.Timeout.should.equal '30'
    response.DescribeLoadBalancersResult.LoadBalancerDescriptions[0].member[0].HealthCheck.UnhealthyThreshold.should.equal '1'
    response.DescribeLoadBalancersResult.LoadBalancerDescriptions[0].member[0].HealthCheck.HealthyThreshold.should.equal '1'
    response.DescribeLoadBalancersResult.LoadBalancerDescriptions[0].member[0].Filter.FilterType.should.equal '1'
    response.DescribeLoadBalancersResult.LoadBalancerDescriptions[0].member[0].Filter.IPAddresses.member[0].should.equal '111.111.111.111'
    response.DescribeLoadBalancersResult.LoadBalancerDescriptions[0].member[0].Filter.IPAddresses.member[1].should.equal '111.111.111.112'
    response.DescribeLoadBalancersResult.LoadBalancerDescriptions[0].member[0].AvailabilityZones.member[0].should.equal 'ap-japan-1a'
    response.DescribeLoadBalancersResult.LoadBalancerDescriptions[0].member[0].CreatedTime.should.equal '2010-05-17T11:22:33.456Z'

    response.DescribeLoadBalancersResult.LoadBalancerDescriptions[1].member[0].LoadBalancerName.should.equal 'lb0001'
    response.DescribeLoadBalancersResult.LoadBalancerDescriptions[1].member[0].DNSName.should.equal '10.0.5.222'
    response.DescribeLoadBalancersResult.LoadBalancerDescriptions[1].member[0].NetworkVolume.should.equal '10'
    response.DescribeLoadBalancersResult.LoadBalancerDescriptions[1].member[0].ListenerDescriptions.member[0].Protocol.should.equal 'http'
    response.DescribeLoadBalancersResult.LoadBalancerDescriptions[1].member[0].ListenerDescriptions.member[0].LoadBalancerPort.should.equal '443'
    response.DescribeLoadBalancersResult.LoadBalancerDescriptions[1].member[0].ListenerDescriptions.member[0].InstancePort.should.equal '443'
    response.DescribeLoadBalancersResult.LoadBalancerDescriptions[1].member[0].ListenerDescriptions.member[0].balancingType.should.equal '2'
    response.DescribeLoadBalancersResult.LoadBalancerDescriptions[1].member[0].Instances.member[0].InstanceId[0].should.equal 'server02'
    response.DescribeLoadBalancersResult.LoadBalancerDescriptions[1].member[0].Instances.member[0].InstanceId[1].should.equal 'server03'
    response.DescribeLoadBalancersResult.LoadBalancerDescriptions[1].member[0].HealthCheck.Target.should.equal 'TCP:443'
    response.DescribeLoadBalancersResult.LoadBalancerDescriptions[1].member[0].HealthCheck.Interval.should.equal '300'
    response.DescribeLoadBalancersResult.LoadBalancerDescriptions[1].member[0].HealthCheck.Timeout.should.equal '30'
    response.DescribeLoadBalancersResult.LoadBalancerDescriptions[1].member[0].HealthCheck.UnhealthyThreshold.should.equal '1'
    response.DescribeLoadBalancersResult.LoadBalancerDescriptions[1].member[0].HealthCheck.HealthyThreshold.should.equal '1'
    response.DescribeLoadBalancersResult.LoadBalancerDescriptions[1].member[0].Filter.FilterType.should.equal '1'
    response.DescribeLoadBalancersResult.LoadBalancerDescriptions[1].member[0].Filter.IPAddresses.member[0].should.equal '*.*.*.*'
    response.DescribeLoadBalancersResult.LoadBalancerDescriptions[1].member[0].AvailabilityZones.member[0].should.equal 'ap-japan-1a'
    response.DescribeLoadBalancersResult.LoadBalancerDescriptions[1].member[0].CreatedTime.should.equal '2010-05-17T11:22:43.789Z'

    response.ResponseMetadata.RequestId.should.equal 'f6dd8353-eb6b-6b4fd32e4f05'
  end

  specify "describe_load_balancers - パラメータが正しく作られるか" do
    @api.stubs(:make_request).with("Action" => "DescribeLoadBalancers",
                                   "LoadBalancerNames.member.1" => "a",
                                   "LoadBalancerNames.member.2" => "a",
                                   "LoadBalancerNames.LoadBalancerPort.1" => "80",
                                   "LoadBalancerNames.LoadBalancerPort.2" => "80",
                                   "LoadBalancerNames.InstancePort.1" => "80",
                                   "LoadBalancerNames.InstancePort.2" => "80"
                                  ).returns stub(:body => @describe_load_balancers_response_body, :is_a? => true)
    @api.stubs(:exec_request).returns stub(:body => @describe_load_balancers_response_body, :is_a? => true)
    response = @api.describe_load_balancers(:load_balancer_name => %w(a a), :load_balancer_port => %w(80 80), :instance_port => %w(80 80))
  end

  specify "describe_load_balancers - :member正常" do
    @api.stubs(:exec_request).returns stub(:body => @describe_load_balancers_response_body, :is_a? => true)
    lambda { @api.describe_load_balancers(:member => 'foo') }.should.not.raise(NIFTY::ArgumentError)
    lambda { @api.describe_load_balancers(:member => %w(foo bar hoge)) }.should.not.raise(NIFTY::ArgumentError)
  end
  
  specify "describe_load_balancers - :load_balancer_port正常" do
    @api.stubs(:exec_request).returns stub(:body => @describe_load_balancers_response_body, :is_a? => true)
    @valid_port.each do |port|
      lambda { @api.describe_load_balancers(:load_balancer_port => port) }.should.not.raise(NIFTY::ArgumentError)
      lambda { @api.describe_load_balancers(:load_balancer_port => [port, port]) }.should.not.raise(NIFTY::ArgumentError)
    end
  end

  specify "describe_load_balancers - :instance_port正常" do
    @api.stubs(:exec_request).returns stub(:body => @describe_load_balancers_response_body, :is_a? => true)
    @valid_port.each do |port|
      lambda { @api.describe_load_balancers(:instance_port => port) }.should.not.raise(NIFTY::ArgumentError)
      lambda { @api.describe_load_balancers(:instance_port => [port, port]) }.should.not.raise(NIFTY::ArgumentError)
    end
  end


  # register_port_with_load_balancer
  specify "register_port_with_load_balancer - レスポンスを正しく解析できるか" do
    @api.stubs(:exec_request).returns stub(:body => @register_port_with_load_balancer_response_body, :is_a? => true)
    response = @api.register_port_with_load_balancer(:load_balancer_name => 'lb1', :listeners => {:protocol => 'HTTPS'})
    response.RegisterPortWithLoadBalancerResult.ListenerDescriptions.member[0].Listener.Protocol.should.equal 'http'
    response.RegisterPortWithLoadBalancerResult.ListenerDescriptions.member[0].Listener.LoadBalancerPort.should.equal '80'
    response.RegisterPortWithLoadBalancerResult.ListenerDescriptions.member[0].Listener.InstancePort.should.equal '80'
    response.RegisterPortWithLoadBalancerResult.ListenerDescriptions.member[0].Listener.balancingType.should.equal '1'
    response.RegisterPortWithLoadBalancerResult.ListenerDescriptions.member[1].Listener.Protocol.should.equal 'https'
    response.RegisterPortWithLoadBalancerResult.ListenerDescriptions.member[1].Listener.LoadBalancerPort.should.equal '443'
    response.RegisterPortWithLoadBalancerResult.ListenerDescriptions.member[1].Listener.InstancePort.should.equal '443'
    response.RegisterPortWithLoadBalancerResult.ListenerDescriptions.member[1].Listener.balancingType.should.equal '1'
    response.ResponseMetadata.RequestId.should.equal 'f6dd8353-eb6b-6b4fd32e4f05'
  end

  specify "register_port_with_load_balancer - パラメータが正しく作られるか" do
    @api.stubs(:make_request).with("Action" => "RegisterPortWithLoadBalancer",
                                   "LoadBalancerName" => "a",
                                   "Listeners.member.1.Protocol" => "HTTP",
                                   "Listeners.member.2.Protocol" => "HTTP",
                                   "Listeners.member.1.LoadBalancerPort" => "80",
                                   "Listeners.member.2.LoadBalancerPort" => "80",
                                   "Listeners.member.1.InstancePort" => "80",
                                   "Listeners.member.2.InstancePort" => "80",
                                   "Listeners.member.1.BalancingType" => "1",
                                   "Listeners.member.2.BalancingType" => "1"
                                  ).returns stub(:body => @register_port_with_load_balancer_response_body, :is_a? => true)
    @api.stubs(:exec_request).returns stub(:body => @register_port_with_load_balancer_response_body, :is_a? => true)
    response = @api.register_port_with_load_balancer(:load_balancer_name => "a", :listeners => [{:protocol => "HTTP", :load_balancer_port => 80, :instance_port => 80, :balancing_type => 1},{:protocol => "HTTP", :load_balancer_port => 80, :instance_port => 80, :balancing_type => 1}])
  end

  specify "register_port_with_load_balancer - :listeners - :protocol正常" do
    @api.stubs(:exec_request).returns stub(:body => @register_port_with_load_balancer_response_body, :is_a? => true)
    @valid_protocol.each do |protocol|
      lambda { @api.register_port_with_load_balancer(:load_balancer_name => 'lb1', :listeners => {:protocol => protocol}) }.should.not.raise(NIFTY::ArgumentError)
      lambda { @api.register_port_with_load_balancer(:load_balancer_name => 'lb1', :listeners => [{:protocol => protocol}, {:protocol => protocol}]) }.should.not.raise(NIFTY::ArgumentError)
    end
  end
  
  specify "register_port_with_load_balancer - :listeners - :load_balancer_port正常" do
    @api.stubs(:exec_request).returns stub(:body => @register_port_with_load_balancer_response_body, :is_a? => true)
    @valid_port.each do |port|
      lambda { @api.register_port_with_load_balancer(:load_balancer_name => 'lb1', :listeners => {:load_balancer_port => port}) }.should.not.raise(NIFTY::ArgumentError)
      lambda { @api.register_port_with_load_balancer(:load_balancer_name => 'lb1', :listeners => [{:load_balancer_port => port}, {:load_balancer_port => port}]) }.should.not.raise(NIFTY::ArgumentError)
    end
  end
  
  specify "register_port_with_load_balancer - :instance_port正常" do
    @api.stubs(:exec_request).returns stub(:body => @register_port_with_load_balancer_response_body, :is_a? => true)
    @valid_port.each do |port|
      lambda { @api.register_port_with_load_balancer(:load_balancer_name => 'lb1', :listeners => {:load_balancer_port => 80, :instance_port => port}) }.should.not.raise(NIFTY::ArgumentError)
      lambda { @api.register_port_with_load_balancer(:load_balancer_name => 'lb1', :listeners => [{:load_balancer_port => 80, :instance_port => port}, {:load_balancer_port => 80, :instance_port => port}]) }.should.not.raise(NIFTY::ArgumentError)
    end
  end
  
  specify "register_port_with_load_balancer - :balancing_type正常" do
    @api.stubs(:exec_request).returns stub(:body => @register_port_with_load_balancer_response_body, :is_a? => true)
    @valid_balancing_type.each do |type|
      lambda { @api.register_port_with_load_balancer(:load_balancer_name => 'lb1', :listeners => {:load_balancer_port => 80, :balancing_type => type}) }.should.not.raise(NIFTY::ArgumentError)
      lambda { @api.register_port_with_load_balancer(:load_balancer_name => 'lb1', :listeners => [{:load_balancer_port => 80, :balancing_type => type}, {:load_balancer_port => 80, :balancing_type => type}]) }.should.not.raise(NIFTY::ArgumentError)
    end
  end
  
  specify "register_port_with_load_balancer - :load_balancer_name未指定" do
    lambda { @api.register_port_with_load_balancer }.should.raise(NIFTY::ArgumentError)
    lambda { @api.register_port_with_load_balancer(:load_balancer_name => nil) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.register_port_with_load_balancer(:load_balancer_name => '') }.should.raise(NIFTY::ArgumentError)
  end
  
  specify "register_port_with_load_balancer - :listeners未指定" do
    lambda { @api.register_port_with_load_balancer(:load_balancer_name => 'lb1') }.should.raise(NIFTY::ArgumentError)
    lambda { @api.register_port_with_load_balancer(:load_balancer_name => 'lb1', :listeners => nil) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.register_port_with_load_balancer(:load_balancer_name => 'lb1', :listeners => '') }.should.raise(NIFTY::ArgumentError)
    lambda { @api.register_port_with_load_balancer(:load_balancer_name => 'lb1', :listeners => []) }.should.raise(NIFTY::ArgumentError)
  end
  
  specify "register_port_with_load_balancer - :protocol, :load_balancer_port未指定/不正" do
    lambda { @api.register_port_with_load_balancer(:load_balancer_name => 'lb1', :listeners => [:protocol => nil]) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.register_port_with_load_balancer(:load_balancer_name => 'lb1', :listeners => [:protocol => '']) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.register_port_with_load_balancer(:load_balancer_name => 'lb1', :listeners => [:protocol => 'foo']) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.register_port_with_load_balancer(:load_balancer_name => 'lb1', :listeners => [{:protocol => 'foo'}, {:protocol => 'bar'}]) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.register_port_with_load_balancer(:load_balancer_name => 'lb1', :listeners => [:load_balancer_port => nil]) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.register_port_with_load_balancer(:load_balancer_name => 'lb1', :listeners => [:load_balancer_port => '']) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.register_port_with_load_balancer(:load_balancer_name => 'lb1', :listeners => [:load_balancer_port => 65536]) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.register_port_with_load_balancer(:load_balancer_name => 'lb1', :listeners => [{:load_balancer_port => 80}, {:load_balancer_port => 65536}]) }.should.raise(NIFTY::ArgumentError)
  end
  
  specify "register_port_with_load_balancer - :instance_port不正" do
    lambda { @api.register_port_with_load_balancer }.should.raise(NIFTY::ArgumentError)
    lambda { @api.register_port_with_load_balancer(:load_balancer_name => 'lb1', :listeners => [{:protocol => 'HTTP', :instance_port => 65536}]) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.register_port_with_load_balancer(:load_balancer_name => 'lb1', :listeners => [{:protocol => 'HTTP', :instance_port => 8080}, {:protocol => 'HTTP', :instance_port => -1}]) }.should.raise(NIFTY::ArgumentError)
  end
  
  specify "register_port_with_load_balancer - :balancing_type不正" do
    lambda { @api.register_port_with_load_balancer(:load_balancer_name => 'lb1', :listeners => [{:protocol => 'HTTP', :balancing_type => 3}]) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.register_port_with_load_balancer(:load_balancer_name => 'lb1', :listeners => [{:protocol => 'HTTP', :balancing_type => 4}, {:protocol => 'HTTP', :balancing_type => 5}]) }.should.raise(NIFTY::ArgumentError)
  end
  
 
  # register_instances_with_load_balancer
  specify "register_instances_with_load_balancer - レスポンスを正しく解析できるか" do
    @api.stubs(:exec_request).returns stub(:body => @register_instances_with_load_balancer_response_body, :is_a? => true)
    response = @api.register_instances_with_load_balancer(:load_balancer_name => 'lb1', :load_balancer_port => 80, :instance_port => 80, :instances => 'serv01')
    response.RegisterInstancesWithLoadBalancerResult.Instances.member[0].InstanceId.should.equal 'server02'
    response.ResponseMetadata.RequestId.should.equal 'f6dd8353-eb6b-6b4fd32e4f05'
  end

  specify "register_instances_with_load_balancer - パラメータが正しく作られるか" do
    @api.stubs(:make_request).with("Action" => "RegisterInstancesWithLoadBalancer",
                                   "LoadBalancerName" => "a",
                                   "LoadBalancerPort" => "80",
                                   "InstancePort" => "80",
                                   "Instances.member.1.InstanceId" => "a",
                                   "Instances.member.2.InstanceId" => "a"
                                  ).returns stub(:body => @register_instances_with_load_balancer_response_body, :is_a? => true)
    @api.stubs(:exec_request).returns stub(:body => @register_instances_with_load_balancer_response_body, :is_a? => true)
    response = @api.register_instances_with_load_balancer(:load_balancer_name => "a", :load_balancer_port => 80, :instance_port => 80, :instances => %w(a a))
  end

  specify "register_instances_with_load_balancer - :load_balancer_port正常" do
    @api.stubs(:exec_request).returns stub(:body => @register_instances_with_load_balancer_response_body, :is_a? => true)
    @valid_port.each do |port|
      lambda { @api.register_instances_with_load_balancer(@basic_reg_instance_params.merge(:load_balancer_port => port)) }.should.not.raise(NIFTY::ArgumentError)
    end
  end
  
  specify "register_instances_with_load_balancer - :instance_port正常" do
    @api.stubs(:exec_request).returns stub(:body => @register_instances_with_load_balancer_response_body, :is_a? => true)
    @valid_port.each do |port|
      lambda { @api.register_instances_with_load_balancer(@basic_reg_instance_params.merge(:instance_port => port)) }.should.not.raise(NIFTY::ArgumentError)
    end
  end
  
  specify "register_instances_with_load_balancer - :instances正常" do
    @api.stubs(:exec_request).returns stub(:body => @register_instances_with_load_balancer_response_body, :is_a? => true)
    lambda { @api.register_instances_with_load_balancer(@basic_reg_instance_params.merge(:instances => 'foo')) }.should.not.raise(NIFTY::ArgumentError)
    lambda { @api.register_instances_with_load_balancer(@basic_reg_instance_params.merge(:instances => %w(foo bar hoge))) }.should.not.raise(NIFTY::ArgumentError)
  end
  
  specify "register_instances_with_load_balancer - :load_balancer_name未指定" do
    lambda { @api.register_instances_with_load_balancer }.should.raise(NIFTY::ArgumentError)
    lambda { @api.register_instances_with_load_balancer(:load_balancer_name => nil) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.register_instances_with_load_balancer(:load_balancer_name => '') }.should.raise(NIFTY::ArgumentError)
  end

  specify "register_instances_with_load_balancer - :load_balancer_port未指定/不正" do
    lambda { @api.register_instances_with_load_balancer(:load_balancer_name => 'foo') }.should.raise(NIFTY::ArgumentError)
    lambda { @api.register_instances_with_load_balancer(:load_balancer_name => 'foo', :load_balancer_port => nil) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.register_instances_with_load_balancer(:load_balancer_name => 'foo', :load_balancer_port => '') }.should.raise(NIFTY::ArgumentError)
    lambda { @api.register_instances_with_load_balancer(:load_balancer_name => 'foo', :load_balancer_port => -1) }.should.raise(NIFTY::ArgumentError)
  end

  specify "register_instances_with_load_balancer - :instance_port未指定/不正" do
    lambda { @api.register_instances_with_load_balancer(:load_balancer_name => 'foo', :load_balancer_port => 80) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.register_instances_with_load_balancer(:load_balancer_name => 'foo', :load_balancer_port => 80, :instance_port => nil) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.register_instances_with_load_balancer(:load_balancer_name => 'foo', :load_balancer_port => 80, :instance_port => '') }.should.raise(NIFTY::ArgumentError)
    lambda { @api.register_instances_with_load_balancer(:load_balancer_name => 'foo', :load_balancer_port => 80, :instance_port => -1) }.should.raise(NIFTY::ArgumentError)
  end

  specify "register_instances_with_load_balancer - :instances未指定" do
    lambda { @api.register_instances_with_load_balancer(:load_balancer_name => 'foo', :load_balancer_port => 80, :instance_port => 80) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.register_instances_with_load_balancer(:load_balancer_name => 'foo', :load_balancer_port => 80, :instance_port => 80, :instances => nil) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.register_instances_with_load_balancer(:load_balancer_name => 'foo', :load_balancer_port => 80, :instance_port => 80, :instances => '') }.should.raise(NIFTY::ArgumentError)
  end


  # deregister_instances_from_load_balancer
  specify "deregister_instances_from_load_balancer - レスポンスを正しく解析できるか" do
    @api.stubs(:exec_request).returns stub(:body => @deregister_instances_from_load_balancer_response_body, :is_a? => true)
    response = @api.deregister_instances_from_load_balancer(:load_balancer_name => 'lb1', :load_balancer_port => 80, :instance_port => 80, :instances => 'serv01')
    response.DeregisterInstancesFromLoadBalancerResult.Instances.member[0].InstanceId.should.equal 'server03'
    response.ResponseMetadata.RequestId.should.equal 'f6dd8353-eb6b-6b4fd32e4f05'
  end

  specify "deregister_instances_from_load_balancer - パラメータが正しく作られるか" do
    @api.stubs(:make_request).with("Action" => "DeregisterInstancesFromLoadBalancer",
                                   "LoadBalancerName" => "a",
                                   "LoadBalancerPort" => "80",
                                   "InstancePort" => "80",
                                   "Instances.member.1.InstanceId" => "a",
                                   "Instances.member.2.InstanceId" => "a"
                                  ).returns stub(:body => @deregister_instances_from_load_balancer_response_body, :is_a? => true)
    @api.stubs(:exec_request).returns stub(:body => @deregister_instances_from_load_balancer_response_body, :is_a? => true)
    response = @api.deregister_instances_from_load_balancer(:load_balancer_name => "a", :load_balancer_port => 80, :instance_port => 80, :instances => %w(a a))
  end

  specify "deregister_instances_from_load_balancer - :load_balancer_port正常" do
    @api.stubs(:exec_request).returns stub(:body => @deregister_instances_from_load_balancer_response_body, :is_a? => true)
    @valid_port.each do |port|
      lambda { @api.deregister_instances_from_load_balancer(@basic_reg_instance_params.merge(:load_balancer_port => port)) }.should.not.raise(NIFTY::ArgumentError)
    end
  end
  
  specify "deregister_instances_from_load_balancer - :instance_port正常" do
    @api.stubs(:exec_request).returns stub(:body => @deregister_instances_from_load_balancer_response_body, :is_a? => true)
    @valid_port.each do |port|
      lambda { @api.deregister_instances_from_load_balancer(@basic_reg_instance_params.merge(:instance_port => port)) }.should.not.raise(NIFTY::ArgumentError)
    end
  end
  
  specify "deregister_instances_from_load_balancer - :instances正常" do
    @api.stubs(:exec_request).returns stub(:body => @deregister_instances_from_load_balancer_response_body, :is_a? => true)
    lambda { @api.deregister_instances_from_load_balancer(@basic_reg_instance_params.merge(:instances => 'foo')) }.should.not.raise(NIFTY::ArgumentError)
    lambda { @api.deregister_instances_from_load_balancer(@basic_reg_instance_params.merge(:instances => %w(foo bar hoge))) }.should.not.raise(NIFTY::ArgumentError)
  end
  
  specify "deregister_instances_from_load_balancer - :load_balancer_name未指定" do
    lambda { @api.deregister_instances_from_load_balancer }.should.raise(NIFTY::ArgumentError)
    lambda { @api.deregister_instances_from_load_balancer(:load_balancer_name => nil) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.deregister_instances_from_load_balancer(:load_balancer_name => '') }.should.raise(NIFTY::ArgumentError)
  end

  specify "deregister_instances_from_load_balancer - :load_balancer_port未指定/不正" do
    lambda { @api.deregister_instances_from_load_balancer(:load_balancer_name => 'foo') }.should.raise(NIFTY::ArgumentError)
    lambda { @api.deregister_instances_from_load_balancer(:load_balancer_name => 'foo', :load_balancer_port => nil) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.deregister_instances_from_load_balancer(:load_balancer_name => 'foo', :load_balancer_port => '') }.should.raise(NIFTY::ArgumentError)
    lambda { @api.deregister_instances_from_load_balancer(:load_balancer_name => 'foo', :load_balancer_port => 65536) }.should.raise(NIFTY::ArgumentError)
  end

  specify "deregister_instances_from_load_balancer - :instance_port未指定/不正" do
    lambda { @api.deregister_instances_from_load_balancer(:load_balancer_name => 'foo', :load_balancer_port => 80) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.deregister_instances_from_load_balancer(:load_balancer_name => 'foo', :load_balancer_port => 80, :instance_port => nil) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.deregister_instances_from_load_balancer(:load_balancer_name => 'foo', :load_balancer_port => 80, :instance_port => '') }.should.raise(NIFTY::ArgumentError)
    lambda { @api.deregister_instances_from_load_balancer(:load_balancer_name => 'foo', :load_balancer_port => 80, :instance_port => -1) }.should.raise(NIFTY::ArgumentError)
  end

  specify "deregister_instances_from_load_balancer - :instances未指定" do
    lambda { @api.deregister_instances_from_load_balancer(:load_balancer_name => 'foo', :load_balancer_port => 80, :instance_port => 80) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.deregister_instances_from_load_balancer(:load_balancer_name => 'foo', :load_balancer_port => 80, :instance_port => 80, :instances => nil) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.deregister_instances_from_load_balancer(:load_balancer_name => 'foo', :load_balancer_port => 80, :instance_port => 80, :instances => '') }.should.raise(NIFTY::ArgumentError)
  end

  
  
  # describe_instance_health
  specify "describe_instance_health - レスポンスを正しく解析できるか" do
    @api.stubs(:exec_request).returns stub(:body => @describe_instance_health_response_body, :is_a? => true)
    response = @api.describe_instance_health(:load_balancer_name => 'lb1', :load_balancer_port => 80, :instance_port => 80, :instances => 'serv01')
    response.DescribeInstanceHealthResult.InstanceStates.member[0].InstanceId.should.equal 'server02'
    response.DescribeInstanceHealthResult.InstanceStates.member[0].State.should.equal 'InService'
    response.DescribeInstanceHealthResult.InstanceStates.member[0].ReasonCode.should.equal 'N/A'
    response.DescribeInstanceHealthResult.InstanceStates.member[0].Description.should.equal 'N/A'
    response.DescribeInstanceHealthResult.InstanceStates.member[1].InstanceId.should.equal 'server06'
    response.DescribeInstanceHealthResult.InstanceStates.member[1].State.should.equal 'OutOfService'
    response.DescribeInstanceHealthResult.InstanceStates.member[1].ReasonCode.should.equal 'ELB'
    response.DescribeInstanceHealthResult.InstanceStates.member[1].Description.should.equal 'Instance registration is still in progress'

    response.ResponseMetadata.RequestId.should.equal 'f6dd8353-eb6b-6b4fd32e4f05'
  end

  specify "describe_instance_health - パラメータが正しく作られるか" do
    @api.stubs(:make_request).with("Action" => "DescribeInstanceHealth",
                                   "LoadBalancerName" => "a",
                                   "LoadBalancerPort" => "80",
                                   "InstancePort" => "80",
                                   "Instances.member.1.InstanceId" => "a",
                                   "Instances.member.2.InstanceId" => "a"
                                  ).returns stub(:body => @describe_instance_health_response_body, :is_a? => true)
    @api.stubs(:exec_request).returns stub(:body => @describe_instance_health_response_body, :is_a? => true)
    response = @api.describe_instance_health(:load_balancer_name => "a", :load_balancer_port => 80, :instance_port => 80, :instances => %w(a a))
  end

  specify "describe_instance_health - :load_balancer_port正常" do
    @api.stubs(:exec_request).returns stub(:body => @describe_instance_health_response_body, :is_a? => true)
    @valid_port.each do |port|
      lambda { @api.describe_instance_health(@basic_desc_instance_health_params.merge(:load_balancer_port => port)) }.should.not.raise(NIFTY::ArgumentError)
    end
  end
  
  specify "describe_instance_health - :instance_port正常" do
    @api.stubs(:exec_request).returns stub(:body => @describe_instance_health_response_body, :is_a? => true)
    @valid_port.each do |port|
      lambda { @api.describe_instance_health(@basic_desc_instance_health_params.merge(:instance_port => port)) }.should.not.raise(NIFTY::ArgumentError)
    end
  end
  
  specify "describe_instance_health - :instances正常" do
    @api.stubs(:exec_request).returns stub(:body => @describe_instance_health_response_body, :is_a? => true)
    lambda { @api.describe_instance_health(@basic_desc_instance_health_params.merge(:instances => 'foo')) }.should.not.raise(NIFTY::ArgumentError)
    lambda { @api.describe_instance_health(@basic_desc_instance_health_params.merge(:instances => %w(foo bar hoge))) }.should.not.raise(NIFTY::ArgumentError)
  end
  
  specify "describe_instance_health - :load_balancer_name未指定" do
    lambda { @api.describe_instance_health }.should.raise(NIFTY::ArgumentError)
    lambda { @api.describe_instance_health(:load_balancer_name => nil) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.describe_instance_health(:load_balancer_name => '') }.should.raise(NIFTY::ArgumentError)
  end

  specify "describe_instance_health - :load_balancer_port未指定/不正" do
    lambda { @api.describe_instance_health(:load_balancer_name => 'foo') }.should.raise(NIFTY::ArgumentError)
    lambda { @api.describe_instance_health(:load_balancer_name => 'foo', :load_balancer_port => nil) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.describe_instance_health(:load_balancer_name => 'foo', :load_balancer_port => '') }.should.raise(NIFTY::ArgumentError)
    lambda { @api.describe_instance_health(:load_balancer_name => 'foo', :load_balancer_port => 65536) }.should.raise(NIFTY::ArgumentError)
  end

  specify "describe_instance_health - :instance_port未指定/不正" do
    lambda { @api.describe_instance_health(:load_balancer_name => 'foo', :load_balancer_port => 80) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.describe_instance_health(:load_balancer_name => 'foo', :load_balancer_port => 80, :instance_port => nil) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.describe_instance_health(:load_balancer_name => 'foo', :load_balancer_port => 80, :instance_port => '') }.should.raise(NIFTY::ArgumentError)
    lambda { @api.describe_instance_health(:load_balancer_name => 'foo', :load_balancer_port => 80, :instance_port => -1) }.should.raise(NIFTY::ArgumentError)
  end
  
  
  # configure_health_check
  specify "configure_health_check - レスポンスを正しく解析できるか" do
    @api.stubs(:exec_request).returns stub(:body => @configure_health_check_response_body, :is_a? => true)
    response = @api.configure_health_check(:load_balancer_name => 'lb1', :load_balancer_port => 80, :instance_port => 80, :target => 'TCP:80', :interval => 30, :unhealthy_threshold => 1)
    response.ConfigureHealthCheckResult.HealthCheck.Target.should.equal 'TCP:80'
    response.ConfigureHealthCheckResult.HealthCheck.Interval.should.equal '300'
    response.ConfigureHealthCheckResult.HealthCheck.Timeout.should.equal '30'
    response.ConfigureHealthCheckResult.HealthCheck.UnhealthyThreshold.should.equal '3'
    response.ConfigureHealthCheckResult.HealthCheck.HealthyThreshold.should.equal '1'
    response.ResponseMetadata.RequestId.should.equal 'f6dd8353-eb6b-6b4fd32e4f05'
  end

  specify "configure_health_check - パラメータが正しく作られるか" do
    @api.stubs(:make_request).with("Action" => "ConfigureHealthCheck",
                                   "LoadBalancerName" => "a",
                                   "LoadBalancerPort" => "80",
                                   "InstancePort" => "80",
                                   "HealthCheck.Target" => "TCP:80",
                                   "HealthCheck.Interval" => "300",
                                   "HealthCheck.Timeout" => "a",
                                   "HealthCheck.UnhealthyThreshold" => "1",
                                   "HealthCheck.HealthyThreshold" => "1"
                                  ).returns stub(:body => @configure_health_check_response_body, :is_a? => true)
    @api.stubs(:exec_request).returns stub(:body => @configure_health_check_response_body, :is_a? => true)
    response = @api.configure_health_check(:load_balancer_name => "a", :load_balancer_port => 80, :instance_port => 80, :target => "TCP:80", :interval => 300, :timeout => "a", :unhealthy_threshold => 1, :healthy_threshold => 1)
  end

  specify "configure_health_check - :load_balancer_name, :load_balancer_port正常" do
    @api.stubs(:exec_request).returns stub(:body => @configure_health_check_response_body, :is_a? => true)
    @valid_port.each do |port|
      lambda { @api.configure_health_check(@basic_conf_health_params.merge(:load_balancer_port => port)) }.should.not.raise(NIFTY::ArgumentError)
    end
  end
  
  specify "configure_health_check - :instance_port正常" do
    @api.stubs(:exec_request).returns stub(:body => @configure_health_check_response_body, :is_a? => true)
    @valid_port.each do |port|
      lambda { @api.configure_health_check(@basic_conf_health_params.merge(:instance_port => port)) }.should.not.raise(NIFTY::ArgumentError)
    end
  end
  
  specify "configure_health_check - :target正常" do
    @api.stubs(:exec_request).returns stub(:body => @configure_health_check_response_body, :is_a? => true)
    lambda { @api.configure_health_check(@basic_conf_health_params.merge(:target => 'TCP:22')) }.should.not.raise(NIFTY::ArgumentError)
    lambda { @api.configure_health_check(@basic_conf_health_params.merge(:target => 'TCP:8080')) }.should.not.raise(NIFTY::ArgumentError)
    lambda { @api.configure_health_check(@basic_conf_health_params.merge(:target => 'ICMP')) }.should.not.raise(NIFTY::ArgumentError)
  end
  
  specify "configure_health_check - :interval正常" do
    @api.stubs(:exec_request).returns stub(:body => @configure_health_check_response_body, :is_a? => true)
    lambda { @api.configure_health_check(@basic_conf_health_params.merge(:interval => 10)) }.should.not.raise(NIFTY::ArgumentError)
    lambda { @api.configure_health_check(@basic_conf_health_params.merge(:interval => 150)) }.should.not.raise(NIFTY::ArgumentError)
    lambda { @api.configure_health_check(@basic_conf_health_params.merge(:interval => 300)) }.should.not.raise(NIFTY::ArgumentError)
    lambda { @api.configure_health_check(@basic_conf_health_params.merge(:interval => '200')) }.should.not.raise(NIFTY::ArgumentError)
  end
  
  specify "configure_health_check - :timeout正常" do
    @api.stubs(:exec_request).returns stub(:body => @configure_health_check_response_body, :is_a? => true)
    lambda { @api.configure_health_check(@basic_conf_health_params.merge(:timeout => 30)) }.should.not.raise(NIFTY::ArgumentError)
    lambda { @api.configure_health_check(@basic_conf_health_params.merge(:timeout => 60)) }.should.not.raise(NIFTY::ArgumentError)
  end
  
  specify "configure_health_check - :unhealthy_threshold正常" do
    @api.stubs(:exec_request).returns stub(:body => @configure_health_check_response_body, :is_a? => true)
    lambda { @api.configure_health_check(@basic_conf_health_params.merge(:unhealthy_threshold => 1)) }.should.not.raise(NIFTY::ArgumentError)
    lambda { @api.configure_health_check(@basic_conf_health_params.merge(:unhealthy_threshold => 5)) }.should.not.raise(NIFTY::ArgumentError)
    lambda { @api.configure_health_check(@basic_conf_health_params.merge(:unhealthy_threshold => 10)) }.should.not.raise(NIFTY::ArgumentError)
    lambda { @api.configure_health_check(@basic_conf_health_params.merge(:unhealthy_threshold => '3')) }.should.not.raise(NIFTY::ArgumentError)
  end
  
  specify "configure_health_check - :load_balancer_name未指定" do
    lambda { @api.configure_health_check(@basic_conf_health_params.reject{|k, v| k == :load_balancer_name}) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.configure_health_check(@basic_conf_health_params.merge(:load_balancer_name => nil)) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.configure_health_check(@basic_conf_health_params.merge(:load_balancer_name => '')) }.should.raise(NIFTY::ArgumentError)
  end

  specify "configure_health_check - :load_balancer_port未指定/不正" do
    lambda { @api.configure_health_check(@basic_conf_health_params.reject{|k, v| k == :load_balancer_port}) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.configure_health_check(@basic_conf_health_params.merge(:load_balancer_port => nil)) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.configure_health_check(@basic_conf_health_params.merge(:load_balancer_port => '')) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.configure_health_check(@basic_conf_health_params.merge(:load_balancer_port => -1)) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.configure_health_check(@basic_conf_health_params.merge(:load_balancer_port => 65536)) }.should.raise(NIFTY::ArgumentError)
  end

  specify "configure_health_check - :instance_port未指定/不正" do
    lambda { @api.configure_health_check(@basic_conf_health_params.reject{|k, v| k == :instance_port}) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.configure_health_check(@basic_conf_health_params.merge(:instance_port => nil)) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.configure_health_check(@basic_conf_health_params.merge(:instance_port => '')) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.configure_health_check(@basic_conf_health_params.merge(:instance_port => 65536)) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.configure_health_check(@basic_conf_health_params.merge(:instance_port => -1)) }.should.raise(NIFTY::ArgumentError)
  end

  specify "configure_health_check - :target未指定/不正" do
    lambda { @api.configure_health_check(@basic_conf_health_params.reject{|k, v| k == :target}) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.configure_health_check(@basic_conf_health_params.merge(:target => nil)) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.configure_health_check(@basic_conf_health_params.merge(:target => '')) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.configure_health_check(@basic_conf_health_params.merge(:target => 'TCP')) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.configure_health_check(@basic_conf_health_params.merge(:target => 'TCP:-1')) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.configure_health_check(@basic_conf_health_params.merge(:target => 'ICMP:80')) }.should.raise(NIFTY::ArgumentError)
  end

  specify "configure_health_check - :interval未指定/不正" do
    lambda { @api.configure_health_check(@basic_conf_health_params.reject{|k, v| k == :interval}) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.configure_health_check(@basic_conf_health_params.merge(:interval => nil)) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.configure_health_check(@basic_conf_health_params.merge(:interval => '')) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.configure_health_check(@basic_conf_health_params.merge(:interval => 5)) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.configure_health_check(@basic_conf_health_params.merge(:interval => 301)) }.should.raise(NIFTY::ArgumentError)
  end

  specify "configure_health_check - :unhealthy_threshold未指定/不正" do
    lambda { @api.configure_health_check(@basic_conf_health_params.reject{|k, v| k == :unhealthy_threshold}) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.configure_health_check(@basic_conf_health_params.merge(:unhealthy_threshold => nil)) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.configure_health_check(@basic_conf_health_params.merge(:unhealthy_threshold => '')) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.configure_health_check(@basic_conf_health_params.merge(:unhealthy_threshold => 0)) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.configure_health_check(@basic_conf_health_params.merge(:unhealthy_threshold => 20)) }.should.raise(NIFTY::ArgumentError)
  end

  specify "configure_health_check - :healthy_threshold不正" do
    lambda { @api.configure_health_check(@basic_conf_health_params.merge(:healthy_threshold => 0)) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.configure_health_check(@basic_conf_health_params.merge(:healthy_threshold => 2)) }.should.raise(NIFTY::ArgumentError)
  end


  # set_filter_for_load_balancer
  specify "set_filter_for_load_balancer - レスポンスを正しく解析できるか" do
    @api.stubs(:exec_request).returns stub(:body => @set_filter_for_load_balancer_response_body, :is_a? => true)
    response = @api.set_filter_for_load_balancer(:load_balancer_name => 'lb1', :load_balancer_port => 80, :instance_port => 80)
    response.SetFilterForLoadBalancerResult.Filter.FilterType.should.equal '1'
    response.SetFilterForLoadBalancerResult.Filter.IPAddresses.member[0].should.equal '111.111.111.111'
    response.SetFilterForLoadBalancerResult.Filter.IPAddresses.member[1].should.equal '111.111.111.112'
    response.ResponseMetadata.RequestId.should.equal 'f6dd8353-eb6b-6b4fd32e4f05'
  end

  specify "set_filter_for_load_balancer - パラメータが正しく作られるか" do
    @api.stubs(:make_request).with("Action" => "SetFilterForLoadBalancer",
                                   "LoadBalancerName" => "a",
                                   "LoadBalancerPort" => "80",
                                   "InstancePort" => "80",
                                   "IPAddresses.member.1.IPAddress" => "1.1.1.1",
                                   "IPAddresses.member.2.IPAddress" => "1.1.1.1",
                                   "IPAddresses.member.1.AddOnFilter" => "true",
                                   "IPAddresses.member.2.AddOnFilter" => "true",
                                   "FilterType" => "1"
                                  ).returns stub(:body => @set_filter_for_load_balancer_response_body, :is_a? => true)
    @api.stubs(:exec_request).returns stub(:body => @set_filter_for_load_balancer_response_body, :is_a? => true)
    response = @api.set_filter_for_load_balancer(:load_balancer_name => "a", :load_balancer_port => 80, :instance_port => 80, :ip_addresses => [{:ip_address => "1.1.1.1", :add_on_filter => true},{:ip_address => "1.1.1.1", :add_on_filter => true}], :filter_type => 1)
  end

  specify "set_filter_for_load_balancer - :load_balancer_name正常" do
    @api.stubs(:exec_request).returns stub(:body => @set_filter_for_load_balancer_response_body, :is_a? => true)
    @valid_port.each do |port|
      lambda { @api.set_filter_for_load_balancer(@basic_set_filter_params.merge(:load_balancer_port => port)) }.should.not.raise(NIFTY::ArgumentError)
    end
  end
  
  specify "set_filter_for_load_balancer - :instance_port正常" do
    @api.stubs(:exec_request).returns stub(:body => @set_filter_for_load_balancer_response_body, :is_a? => true)
    @valid_port.each do |port|
      lambda { @api.set_filter_for_load_balancer(@basic_set_filter_params.merge(:instance_port => port)) }.should.not.raise(NIFTY::ArgumentError)
    end
  end
  
  specify "set_filter_for_load_balancer - :ip_addresses - :ip_address正常" do
    @api.stubs(:exec_request).returns stub(:body => @set_filter_for_load_balancer_response_body, :is_a? => true)
    lambda { @api.set_filter_for_load_balancer(@basic_set_filter_params.merge(:ip_addresses => {:ip_address => '111.111.111.111'})) }.should.not.raise(NIFTY::ArgumentError)
    lambda { @api.set_filter_for_load_balancer(@basic_set_filter_params.merge(:ip_addresses => [{:ip_address => '111.111.111.111'}, {:ip_address => '::ffff:6f6f:6f6f'}])) }.should.not.raise(NIFTY::ArgumentError)
  end

  specify "set_filter_for_load_balancer - ip_addresses - :add_on_filter正常" do
    @api.stubs(:exec_request).returns stub(:body => @set_filter_for_load_balancer_response_body, :is_a? => true)
    lambda { @api.set_filter_for_load_balancer(@basic_set_filter_params.merge(:ip_addresses => {:add_on_filter => true})) }.should.not.raise(NIFTY::ArgumentError)
    lambda { @api.set_filter_for_load_balancer(@basic_set_filter_params.merge(:ip_addresses => [{:add_on_filter => true}, {:add_on_filter => false}])) }.should.not.raise(NIFTY::ArgumentError)
  end
  
  specify "set_filter_for_load_balancer - :filter_type正常" do
    @api.stubs(:exec_request).returns stub(:body => @set_filter_for_load_balancer_response_body, :is_a? => true)
    lambda { @api.set_filter_for_load_balancer(@basic_set_filter_params.merge(:filter_type => 1)) }.should.not.raise(NIFTY::ArgumentError)
    lambda { @api.set_filter_for_load_balancer(@basic_set_filter_params.merge(:filter_type => 2)) }.should.not.raise(NIFTY::ArgumentError)
    lambda { @api.set_filter_for_load_balancer(@basic_set_filter_params.merge(:filter_type => '1')) }.should.not.raise(NIFTY::ArgumentError)
    lambda { @api.set_filter_for_load_balancer(@basic_set_filter_params.merge(:filter_type => '2')) }.should.not.raise(NIFTY::ArgumentError)
  end
  
  specify "set_filter_for_load_balancer - :load_balancer_name未指定" do
    lambda { @api.set_filter_for_load_balancer(@basic_set_filter_params.reject{|k, v| k == :load_balancer_name}) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.set_filter_for_load_balancer(@basic_set_filter_params.merge(:load_balancer_name => nil)) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.set_filter_for_load_balancer(@basic_set_filter_params.merge(:load_balancer_name => '')) }.should.raise(NIFTY::ArgumentError)
  end

  specify "set_filter_for_load_balancer - :load_balancer_port未指定/不正" do
    lambda { @api.set_filter_for_load_balancer(@basic_set_filter_params.reject{|k, v| k == :load_balancer_port}) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.set_filter_for_load_balancer(@basic_set_filter_params.merge(:load_balancer_port => nil)) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.set_filter_for_load_balancer(@basic_set_filter_params.merge(:load_balancer_port => '')) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.set_filter_for_load_balancer(@basic_set_filter_params.merge(:load_balancer_port => '')) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.set_filter_for_load_balancer(@basic_set_filter_params.merge(:load_balancer_port => -1)) }.should.raise(NIFTY::ArgumentError)
  end

  specify "set_filter_for_load_balancer - :instance_port未指定/不正" do
    lambda { @api.set_filter_for_load_balancer(@basic_set_filter_params.reject{|k, v| k == :instance_port}) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.set_filter_for_load_balancer(@basic_set_filter_params.merge(:instance_port => nil)) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.set_filter_for_load_balancer(@basic_set_filter_params.merge(:instance_port => '')) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.set_filter_for_load_balancer(@basic_set_filter_params.merge(:instance_port => '')) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.set_filter_for_load_balancer(@basic_set_filter_params.merge(:instance_port => -1)) }.should.raise(NIFTY::ArgumentError)
  end

  specify "set_filter_for_load_balancer - ip_addresses - :ip_address不正" do
    lambda { @api.set_filter_for_load_balancer(@basic_set_filter_params.merge(:ip_addresses => {:ip_address => '123.456.789.123'})) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.set_filter_for_load_balancer(@basic_set_filter_params.merge(:ip_addresses => [{:ip_address => '111.111.111.111'}, {:ip_address => '123.456.789.123'}])) }.should.raise(NIFTY::ArgumentError)
  end

  specify "set_filter_for_load_balancer - ip_addresses - :add_on_filter不正" do
    lambda { @api.set_filter_for_load_balancer(@basic_set_filter_params.merge(:ip_addresses => {:add_on_filter => 'foo'})) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.set_filter_for_load_balancer(@basic_set_filter_params.merge(:ip_addresses => [{:add_on_filter => true}, {:add_on_filter => 'hoge'}])) }.should.raise(NIFTY::ArgumentError)
  end

  specify "set_filter_for_load_balancer - :filter_type未指定" do
    lambda { @api.set_filter_for_load_balancer(@basic_set_filter_params.merge(:filter_type => 3)) }.should.raise(NIFTY::ArgumentError)
    lambda { @api.set_filter_for_load_balancer(@basic_set_filter_params.merge(:filter_type => 0)) }.should.raise(NIFTY::ArgumentError)
  end

end
