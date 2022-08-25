


resource "aws_elastic_beanstalk_application" "elasticapp" {
  name = var.application_name
}

resource "aws_elastic_beanstalk_application_version" "nginx" {
  name        = "1"
  application = var.application_name
  description = "${aws_elastic_beanstalk_application.elasticapp.name}, using nginx"
  bucket      = "qbe-bucket"
  # Key can also be changed to Dockerrun.aws.json or .zip for Docker deployments 
  # for alternatives check: https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/single-container-docker-configuration.html
  key         = "Dockerfile"
}

resource "aws_elastic_beanstalk_environment" "beanstalkappenv" {

  name                = var.bean_env_name
  application         = var.application_name
  solution_stack_name = "64bit Amazon Linux 2 v3.4.18 running Docker"
  tags = {
      APP_NAME = var.app_tags
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = var.vpc_id
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = var.ec2_subnets
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBSubnets"
    value     = var.elb_subnets
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "LoadBalancerType"
    value     = "application"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = var.instance_type
  }


  setting {
      namespace = "aws:autoscaling:launchconfiguration"
      name = "IamInstanceProfile"
      value = var.ec2_profile
  }

  # setting {
  #   namespace = "aws:autoscaling:launchconfiguration"
  #   name      = "SecurityGroups"
  #   value     = var.security_groups
  # }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBScheme"
    value     = "internal"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "LoadBalanced"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = 2
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = 4
  }
  
  setting {
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name      = "SystemType"
    value     = "enhanced"
  }

  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name      = "RollingUpdateEnabled"
    value     = true
    
  }

  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name      = "RollingUpdateType"
    value     = "Health"
    
  }

    setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ServiceRole"
    # move to var
    value     = "aws-elasticbeanstalk-service-role"
  }

  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name      = "MinInstancesInService"
    value     = 2
  }

  setting {
    namespace = "aws:elasticbeanstalk:command"
    name      = "DeploymentPolicy"
    value     = "Rolling"
    
  }

  setting {
    namespace = "aws:elasticbeanstalk:managedactions"
    name      = "ManagedActionsEnabled"
    value     = false
  }

  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name      = "MaxBatchSize"
    value     = 1
  }


  ###=========================== Logging ========================== ###

  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name      = "StreamLogs"
    value     = true
    
  }

  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs:health"
    name      = "HealthStreamingEnabled"
    value     = true
    
  }

  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name      = "RetentionInDays"
    value     = 7
    
  }

  setting {
    namespace = "aws:elasticbeanstalk:sns:topics"
    name      = "NotificationProtocol"
    value     = "email"
  }


  ###=========================== Load Balancer ========================== ###
  setting { 
    namespace = "aws:elb:listener"
    name      = "ListenerEnabled"
    value     = true
    }

  setting { 
    namespace = "aws:elb:listener"
    name      = "ListenerProtocol"
    value     = "HTTP"
    }

  setting { 
    namespace = "aws:elb:listener"
    name      = "InstancePort"
    value     = var.app_port
    }
  
  setting {
      namespace = "aws:elasticbeanstalk:environment:process:default"
      name      = "Port"
      value     = var.app_port
  }
  
  setting {
      namespace = "aws:elasticbeanstalk:environment:process:default"
      name      = "UnhealthyThresholdCount"
      value     = 10
  }

  setting {
      namespace = "aws:elasticbeanstalk:environment:process:default"
      name      = "HealthCheckInterval"
      value     = 10
  }
  
  setting {
      namespace = "aws:elasticbeanstalk:environment:process:default"
      name      = "HealthCheckPath"
      value     = "/"
  }

  setting {
      namespace = "aws:elasticbeanstalk:environment:process:default"
      name      = "MatcherHTTPCode"
      value     = var.app_http_response
  }

  setting {
      namespace = "aws:elasticbeanstalk:environment:process:default"
      name      = "Protocol"
      value     = "HTTP"
  }

  setting {
      namespace = "aws:elasticbeanstalk:environment:process:default"
      name      = "StickinessEnabled"
      value     = "true"
  }

}




