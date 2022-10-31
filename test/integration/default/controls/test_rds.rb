# frozen_string_literal: true

include_controls 'inspec-aws'
require './test/library/common'

tfstate = StateFileReader.new
s3_id = tfstate.read['outputs']['generic-s3']['value']['bucket']['name'].to_s
s3_prefix_id = tfstate.read['outputs']['generic-s3-prefix']['value']['bucket']['name'].to_s
s3_override_id = tfstate.read['outputs']['generic-s3-override']['value']['bucket']['name'].to_s
s3_options_id = tfstate.read['outputs']['generic-s3-options']['value']['bucket']['name'].to_s

control 'default' do
  describe aws_s3_bucket(s3_id) do
    # https://github.com/inspec/inspec-aws/blob/main/docs/resources/aws_s3_bucket.md
    it { should exist }
    it { should_not be_public }
    it { should_not have_access_logging_enabled }
    it { should have_default_encryption_enabled }
    it { should have_versioning_enabled }
    its('tags') do
      should include 'Name' => s3_id, 'environment' => 'dev', 'terraform' => 'true', 'kitchen' => 'true',
                     'example' => 'true'
    end
  end

  describe aws_s3_bucket(s3_prefix_id) do
    # https://github.com/inspec/inspec-aws/blob/main/docs/resources/aws_s3_bucket.md
    it { should exist }
    it { should_not be_public }
    it { should_not have_access_logging_enabled }
    it { should have_default_encryption_enabled }
    it { should have_versioning_enabled }
    its('tags') do
      should include 'Name' => s3_prefix_id, 'environment' => 'dev', 'terraform' => 'true', 'kitchen' => 'true',
                     'example' => 'true'
    end
  end

  describe aws_s3_bucket(s3_override_id) do
    # https://github.com/inspec/inspec-aws/blob/main/docs/resources/aws_s3_bucket.md
    it { should exist }
    it { should_not be_public }
    it { should_not have_access_logging_enabled }
    it { should have_default_encryption_enabled }
    it { should have_versioning_enabled }
    its('tags') do
      should include 'Name' => s3_override_id, 'environment' => 'dev', 'terraform' => 'true', 'kitchen' => 'true',
                     'example' => 'true'
    end
  end

  describe aws_s3_bucket(s3_options_id) do
    # https://github.com/inspec/inspec-aws/blob/main/docs/resources/aws_s3_bucket.md
    it { should exist }
    it { should_not be_public }
    it { should_not have_access_logging_enabled }
    it { should have_default_encryption_enabled }
    it { should have_versioning_enabled }
    its('tags') do
      should include 'Name' => s3_options_id, 'environment' => 'dev', 'terraform' => 'true', 'kitchen' => 'true',
                     'example' => 'true'
    end
  end
end
