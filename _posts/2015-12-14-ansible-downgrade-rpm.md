---
layout: post
title:  "Downgrade RPMs using Ansible"
date:   2015-12-14 20:48:20 +0000
category: cicd
tags: [Ansible, CI/CD]
---

In a real-world scenario, if a newly deployed RPM does not behave as expected,
doing a rollback, i.e., downgrading the RPM to its previously installed, older
version, is a typical backoff procedure. It surprises me a lot that the Ansible
yum module does not support this out of the box, at least not with version
1.9.4, which I tested. There is [an open pull request for this feature on
Github](https://github.com/ansible/ansible-modules-core/pull/2744).

My solution is using a shell task to do the downgrade when a variable
`rollback` is explicitly set to true. The shell task calls "yum downgrade". The
shell task co-exist with the normal yum task, side by side. Using conditionals,
these two tasks are made mutual exclusive, i.e., only one of the tasks gets
executed at any point in time. The effect is that either a downgrade or an
update of the RPM will be made (or nothing if the desired version is already
installed). The variable can be passed via the command-line like this:
`--extra-vars rollback=true`.

The role can be included in a playbook or included as a dependency of another
role. The code and usage examples are [available
here](https://github.com/ouyi/ansible_yum_updown). 