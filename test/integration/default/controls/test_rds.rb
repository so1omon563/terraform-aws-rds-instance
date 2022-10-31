# frozen_string_literal: true

include_controls 'inspec-aws'
require './test/library/common'

tfstate = StateFileReader.new
rds_id = tfstate.read['outputs']['default-rds']['value']['rds_instance']['id'].to_s
subnet_rds_id = tfstate.read['outputs']['subnet-group-rds']['value']['rds_instance']['id'].to_s

control 'default' do
  describe aws_rds_instance(db_instance_identifier: rds_id) do
    it { should exist }
    its('engine') { should eq 'mysql' }
    its('db_instance_identifier') { should eq rds_id }
  end
  describe aws_rds_instance(db_instance_identifier: subnet_rds_id) do
    it { should exist }
    its('engine') { should eq 'mysql' }
    its('db_instance_identifier') { should eq subnet_rds_id }
  end
end
