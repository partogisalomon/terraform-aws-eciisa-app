locals {
  region_id         = "ap-southeast-1"
  ami_id            = "ami-055c55112e25b1f1f"
  instance_type     = "c5.xlarge"

  service_name      = "eciisa"
  service_role      = "app"
  application       = "RHEL-7.6_HVM_GA-20190128-x86_64-0-Hourly2-GP2 (ami-055c55112e25b1f1f)"
  description       = "Informatica Secure Agent to connect with Anaplan"
  product_domain    = "eci"
  app_service_port  = 443
  root_volume_size  = 100
  recipient         = "partogi.salomon@traveloka.com"

  environment       = "${var.environment}"
  vpc_id            = "${var.vpc_id}"
  subnet_id         = "${var.subnet_id}"
  oebs_app_profile  = "${var.oebs_app_profile}"

  datadog_api_key   = "/tvlk-secret/shared/eci/datadog/datadog.api.key"
  agent_token       = "/tvlk-secret/shared/eci/eciisa/eciisa-app/eciisa-app-token/agent_token.key"

  //todo
  eciisa_role_name          = "InstanceRole_eciisa-app-eb1487e0c44b6198"
  eciisa_instance_profile   = "InstanceProfile_eciisa-app-eb1487e0c44b6198"

  instance_userdata = <<EOF
          #cloud-config

          runcmd:
          - [ sh, -c, 'echo -e "*  -  nofile  32000" | tee -a /etc/security/limits.conf' ]
          - [ sh, -c, 'echo -e "*  -  nproc  32000" | tee -a /etc/security/limits.conf' ]
          - [ sh, -c, 'ulimit -n 32000']
          - [ sh, -c, 'ulimit -u 32000']
          - [ sh, -c, "runuser -l ec2-user -c 'ulimit -n 32000'" ]
          - [ sh, -c, "runuser -l ec2-user -c 'ulimit -u 32000'" ]
          - [ sh, -c, "runuser -l ec2-user -c 'curl -O https://bootstrap.pypa.io/get-pip.py'" ]
          - [ sh, -c, "runuser -l ec2-user -c 'python get-pip.py --user'" ]
          - [ sh, -c, "runuser -l ec2-user -c 'export PATH=~/.local/bin:$PATH'" ]
          - [ sh, -c, "runuser -l ec2-user -c 'source ~/.bash_profile'" ]
          - [ sh, -c, "runuser -l ec2-user -c 'pip install awscli --upgrade --user'" ]
          - [ sh, -c, 'DD_API_KEY=${data.aws_ssm_parameter.datadog_api_key.value} bash -c "$(curl -L https://raw.githubusercontent.com/DataDog/datadog-agent/master/cmd/agent/install_script.sh)"' ]
          - [ sh, -c, 'systemctl stop datadog-agent' ]
          - [ sh, -c, 'echo -e "tags:" | tee -a /etc/datadog-agent/datadog.yaml' ]
          - [ sh, -c, 'echo -e "- cluster:${local.service_name}-${local.service_role}" | tee -a /etc/datadog-agent/datadog.yaml' ]
          - [ sh, -c, 'echo -e "- environment:${local.environment} | tee -a /etc/datadog-agent/datadog.yaml' ]
          - [ sh, -c, 'systemctl start datadog-agent' ]
          - [ sh, -c, "yum -y install java-1.8.0-openjdk-devel" ]
          - [ sh, -c, "yum -y install wget" ]
          - [ sh, -c, "runuser -l ec2-user -c 'wget https://usw3.dm-us.informaticacloud.com/saas/download/linux64/installer/agent64_install_ng_ext.bin'" ]
          - [ sh, -c, "runuser -l ec2-user -c 'chmod a+x agent64_install_ng_ext.bin'" ]
          - [ sh, -c, "runuser -l ec2-user -c './agent64_install_ng_ext.bin -i silent'" ]
          - [ sh, -c, "runuser -l ec2-user -c 'cd infaagent/apps/agentcore/ && ./infaagent startup'" ]
          - [ sh, -c, "runuser -l ec2-user -c 'cd infaagent/apps/agentcore/ && ./consoleAgentManager.sh configureToken falcon.project@traveloka.com ${data.aws_ssm_parameter.agent_token.value}'" ]
          - [ sh, -c, "runuser -l ec2-user -c 'cd infaagent/apps/agentcore/ && ./consoleAgentManager.sh getstatus'" ]
          - [ sh, -c, "runuser -l ec2-user -c 'cd infaagent/apps/agentcore/ && ./consoleAgentManager.sh isConfigured'" ]
  EOF
}