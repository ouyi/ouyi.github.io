---
layout: post
title:  "AWS IAM core concepts explained"
date:   2020-12-18 19:00:00 +0000
last_modified_at: 2020-12-19 21:05:20
category: post
tags: [Cloud, AWS]
---

* TOC
{:toc}
> - _What are policies in IAM?_
> - _What are the differences between groups and roles?_
> - _What is an instance profile and when shall it be used?_
> - _What are the differences between roles and instance profiles?_

These are some of the questions I had while working on a side project on AWS. It turns out that _users_, _groups_, _roles_, and _policies_ are core concepts of AWS _Identity and Access Management (IAM)_. 

IAM is crucial to the security of applications and infrastructures built on AWS. Hopefully, after reading this post, the reader can get a clear understanding of these concepts and their relationships. This post cannot replace any AWS documentation. Their documentation is usually quite good, but it can be verbose and not always easy to understand. 

## What is IAM

IAM is an AWS security feature for managing access to AWS services and resources. It is about authentication and authorization. It is worth mentioning that AWS services and resources are not only accessed by human users, but also by other AWS services such as EC2 or Lambda. Therefore in an AWS context, _authentication_ makes sure that users (or services) are who they claim to be, and _authorization_ allows the authenticated users (or services) access to services and resources they are supposed to access and denies any other accesses.

## The core concepts

The remaining part of this post discusses some of the IAM core concepts. For an easier understanding, it is helpful to know for each of the concepts, whether it is relevant to user access control or to service access control. This is summarized in the following table:

| Concept  | User | Service |
|----------|------|---------|
| Policies | X    | X       |
| Users    | X    |         |
| Groups   | X    |         |
| Roles    | X    | X       |

### Policies

An IAM policy defines a set of permissions. It specifies what kind of accesses are allowed for which resources under what conditions. Policies can be attached to users, groups, and roles[^1]. Attaching a policy to a user gives the user permissions specified in the policy. The implications of attaching a policy to groups and roles are discussed later in this post.

The example[^2] below is a policy that allows an IAM user to start or stop EC2 instances, but only for instances having a `Owner` tag with the value matching the user's username. The `DescribeInstances` permissions are needed to complete this action on the AWS console.

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:StartInstances",
                "ec2:StopInstances"
            ],
            "Resource": "arn:aws:ec2:*:*:instance/*",
            "Condition": {
                "StringEquals": {
                    "ec2:ResourceTag/Owner": "${aws:username}"
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": "ec2:DescribeInstances",
            "Resource": "*"
        }
    ]
}
```

### Users

An _IAM user_ is a person accessing AWS services and resources. Users directly interact with AWS services and have _long-term credentials_, such as AWS access keys and secret keys, X.509 certificates, SSH keys, passwords for web app logins, or MFA devices.

### Groups

An _IAM group_ is a set of IAM users. The policies attached to a group define the permissions shared by its members. Group is a convenience feature for efficiently managing permissions for a set of users. Therefore, although policies can be directly attached to a user, it is a better practice to attach policies to the groups that the user is a member of. 

### Roles

An _IAM role_ defines a set of permissions via the attached policies. Roles cannot make direct requests to AWS services, they are meant to be assumed by _trusted entities_, including IAM users and AWS services such as EC2. The main use case of roles is to delegate accesses with defined permissions to those trusted entities, without having to share long-term credentials with them.

The trust relationship is defined in the role's trust policy when the role is created, as shown in the screenshot below, where the trusted entity can be either an AWS service, or a user (Another AWS account, Web identity, or SAML 2.0 federation).

<img class="center" src="https://user-images.githubusercontent.com/15970333/102698329-ce354280-423c-11eb-9022-5396d57641a1.png" alt="screenshot IAM create role" />

One can even use roles to delegate access between AWS accounts. To assume a role from a different account, that account must be trusted by the role.

A big difference between groups and roles: groups are for users of the same account only, whereas roles can be assumed by users or services, from the same account or other accounts.

## Instance profiles

EC2 is one of the most commonly used AWS services. In the following, we discuss how EC2 instances can utilize roles.

An instance profile is a container for a single IAM Role. It can be mapped to one and only one role. A best practice is to create an IAM Role and an Instance Profile of the same name for clarity.

Normally the applications running on an EC2 instance have to access other AWS services or resources. To be able to do so, they would require the access keys `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`. The administrator would need to manage those keys, and the DevOps would need to make them available to the applications, e.g., by including them in the application configurations. The access keys are long term credentials owned by users, so groups and polices need to be set up properly, so that the applications having those access keys have just the right set of permissions to perform their tasks.

Permissions are defined in policies attached to IAM roles. Can an EC2 instance assume an IAM role which already defined the permissions via the attached policies? This is where instance profiles are useful. If an instance is launched with an instance profile, the corresponding IAM role is passed to the instance. 

The applications running on that instance [automatically get the (short-term) credentials from that instance's metadata service](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/iam-roles-for-amazon-ec2.html#instance-metadata-security-credentials) and have the permissions defined in the role passed via the instance profile. 

The major benefit of using instance profiles is that they remove the need to manage the long-term access keys and deploy them on EC2 instances.

## How they play together 

To grant permissions to a human user, we shall first check if any [AWS managed policy](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_managed-vs-inline.html#aws-managed-policies) can be directly used. If not, a customer managed policy can be created. The policy can be attached to either a group which the user is a member of, or a role which the user can assume. Unfortunately, roles can not be attached to groups -- that would be nice feature.

If the policy is attached to a role contained in an instance profile, any instance launched with the instance profile[^3] will have the role, i.e., applications in that instance will be able to get temporary security credentials, which enable them access services and resources as defined in the policy.

<img class="center" src="https://user-images.githubusercontent.com/15970333/102694734-40009280-4223-11eb-8d60-ee2eb0357bb9.png" alt="How the IAM concepts play together" />

This post gave an overview of the selected IAM core concepts, their use cases, and their relationships. Hopefully you find this useful.

**Footnotes**

[^1]: AWS has multiple policy types. In this post, we only discuss the [identity-based policies](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies.html#policies_id-based). 

[^2]: The source of the example is [here](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_examples_ec2_tag-owner.html).

[^3]: The user launching the instance needs to have the [`RunInstances` and the `PassRole` permissions](https://aws.amazon.com/blogs/security/granting-permission-to-launch-ec2-instances-with-iam-roles-passrole-permission/).
