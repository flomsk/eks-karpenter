resource "kubectl_manifest" "karpenter_node_class_default" {
  yaml_body = <<-YAML
apiVersion: karpenter.k8s.aws/v1beta1
kind: EC2NodeClass
metadata:
  name: default
spec:
  # Required, resolves a default ami and userdata
  amiFamily: AL2023
    
  # Required, discovers subnets to attach to instances
  # Each term in the array of subnetSelectorTerms is ORed together
  # Within a single term, all conditions are ANDed
  subnetSelectorTerms:
    - tags:
        karpenter.sh/discovery: "${var.cluster_name}"

  securityGroupSelectorTerms:
    - tags:
        karpenter.sh/discovery: "${var.cluster_name}"

  # Optional, IAM role to use for the node identity.
  # The "role" field is immutable after EC2NodeClass creation. This may change in the
  # future, but this restriction is currently in place today to ensure that Karpenter
  # avoids leaking managed instance profiles in your account.
  # Must specify one of "role" or "instanceProfile" for Karpenter to launch nodes
  role: "${var.role_name}"

  # Optional, configures storage devices for the instance
  blockDeviceMappings:
    - deviceName: /dev/xvda
      ebs:
        volumeSize: 100Gi
        volumeType: gp3
        encrypted: false
        deleteOnTermination: true

  # Optional, configures detailed monitoring for the instance
  detailedMonitoring: true
YAML

}
