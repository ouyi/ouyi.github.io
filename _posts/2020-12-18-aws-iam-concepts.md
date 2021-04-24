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

IAM is crucial to the security of applications and infrastructures built on AWS. In this post, I would like to share my understanding of IAM and its core concepts.

**TLDR**

- Use policies to define permissions
- To grant long-term permissions to users, attach the policies to groups 
- To grant short-term permissions to users or services, attach the policies to roles 
- To pass a role to EC2 instances, use a corresponding instance profile


## What is IAM

IAM is an AWS security feature for managing access to AWS services and resources. These services and resources are not only accessed by _human users_, but also by _non-human entities_ such as other services, instances, or applications. Therefore the term _security principal_ refers to either a human user or such a non-human entity. AWS IAM covers both aspects of access control: authentication and authorization.

- _Authentication_ validates principals are who they claim to be, and
- _Authorization_ gives the authenticated principals permissions they are supposed to have and denies any other accesses.

## The core concepts

For me it was helpful to know for each of the IAM concepts, whether it is relevant to human users or nonhuman entities. This is summarized in the following table:

| Concept  | Human users | Nonhuman entities |
|----------|------|---------|
| Policies | X    | X       |
| Users    | X    |         |
| Groups   | X    |         |
| Roles    | X    | X       |

### Policies

In IAM, permissions are defined in policies. A _policy_ specifies what kind of accesses are allowed for which resources under what conditions. Policies can be attached to users, groups, and roles[^1]. Attaching a policy to a user gives the user permissions specified in the policy. The implications of attaching a policy to groups or roles are discussed later in this post.

The example[^2] below is a policy that allows an IAM user to start or stop EC2 instances, but only for instances having an `Owner` tag with the value matching the user's username. The `DescribeInstances` permissions are needed to complete this action on the AWS console.

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

An _IAM role_ defines a set of permissions via the attached policies. Roles cannot make direct requests to AWS services, they are meant to be assumed by _trusted entities_, including IAM users and AWS services. The main use case of roles is to delegate accesses with defined permissions to those trusted entities, without having to share long-term credentials with them.

The trust relationship is defined in the role's trust policy when the role is created, as shown in the screenshot below, where the trusted entity can be either an AWS service, or a user (Another AWS account, Web identity, or SAML 2.0 federation). So a role is a container of polices, which define either permissions or trust relationships.

<img class="center" src="https://user-images.githubusercontent.com/15970333/102698329-ce354280-423c-11eb-9022-5396d57641a1.png" alt="screenshot IAM create role" />

One can even use roles to delegate access between AWS accounts. To assume a role from a different account, that account must be trusted by the role.

As mentioned earlier, policies can be attached to both roles and groups. Unfortunately, roles can not be attached to groups -- that would be a nice feature. A big difference between groups and roles: groups are for users of the same account only, whereas roles can be assumed by users or services, from the same account or other accounts.

## Instance profiles

It might be arguable whether instance profile is an IAM core concept -- it is even not visible in the AWS console[^4]. Nevertheless, it is a topic that one shall be aware of when working with EC2, which is no doubt a core AWS service.

An instance profile is a container for a single IAM role -- it can be mapped to one and only one role. An instance can be launched with or without an instance profile. If it is launched with an instances profile, the corresponding role is associated with the instance, or _passed to_ the instance in AWS terms[^3]. This association makes temporary credentials available to the applications on those instances. With the temporary credentials, the applications obtain the permissions defined in the role[^5]. Permissions are required, if the applications need to access other AWS services, which is a typical use case.

Without instance profiles, the way of granting permissions to those applications is to deploy the access keys `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` on the EC2 instances. However, it is challenging to do so: the administrator would need to manage those keys, and the DevOps would need to make them available to the applications, e.g., by including them in the application configurations. The access keys are long term credentials owned by users, so groups and polices need to be set up properly. Key rotations and automatically launched instances make it even more complicated.

So the major benefit of using instance profiles is the removal of long-term credentials from EC2 instances. The difference between roles and instance profiles: roles can be assumed by human users, whereas instance profiles can only be attached to instances at the launch time.

However, I still have an open question for myself and the reader: when launching an instance, would it be easier to directly specify the required IAM role, instead of indirectly specifying the same but via an instance profile, which corresponds 1:1 to the role?

## How they play together

To grant permissions to a human user, we shall first check if any [AWS managed policy](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_managed-vs-inline.html#aws-managed-policies) can be directly used. If not, a customer managed policy can be created. The policy can be attached to either a group which the user is a member of, or a role which the user can assume.

Let's assume a set of permissions (for accessing some sample AWS service or resource) are defined in a policy `p`, which has been attached to a group `g` and a role `r`. 

For an IAM user to obtain permissions defined in `p`, there are two options:

1. being a member of `g`, or 
2. assuming `r`.

For an instance to obtain the same set of permissions, there are also two options:

1. launching it with an instance profile corresponding to role `r`, or 
2. deploying a pair of access and secret keys (created by a member of `g`) on it.

<img class="center" src="https://user-images.githubusercontent.com/15970333/102716135-279f7f00-42da-11eb-946e-2a0022592493.png" alt="How the IAM concepts play together" />

## Summary

This post documents my understanding of IAM and some of its core concepts, their use cases, and their relationships. It cannot replace any AWS documentation -- on the contrary -- the official AWS documentation is the source of truth. However, the understanding from an AWS user's perspective hopefully would be helpful for some other AWS users.


&nbsp;

---

&nbsp;

[^1]: AWS has multiple policy types. In this post, we only discuss the [identity-based policies](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies.html#policies_id-based).

[^2]: The source of the example is [here](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_examples_ec2_tag-owner.html).

[^3]: The user launching the instance needs to have the [`RunInstances` and the `PassRole` permissions](https://aws.amazon.com/blogs/security/granting-permission-to-launch-ec2-instances-with-iam-roles-passrole-permission/).

[^4]: When an IAM role is created using the AWS console, an [instance profile is created automatically behind the scenes by AWS](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/iam-roles-for-amazon-ec2.html).

[^5]: The applications running on that instance [automatically get the (short-term) credentials from that instance's metadata service](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/iam-roles-for-amazon-ec2.html#instance-metadata-security-credentials) and obtain the permissions defined in the role passed via the instance profile.

