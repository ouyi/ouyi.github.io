
## Nomenclature

* [Parallelism](https://www.ansible.com/blog/ansible-performance-tuning)

  - [forks](http://docs.ansible.com/ansible/latest/intro_configuration.html#forks) shall be called *parallelism*, which controls number of processes on the Ansible control host.

  > specify number of parallel processes to use (default=5)
  http://docs.ansible.com/ansible/2.4/ansible.html

  How many remote hosts can be connected by Ansible at a time

  - [serial](http://docs.ansible.com/ansible/latest/playbooks_delegation.html) shall be called *batch size*, which is used for rolling updates.

  How many hosts a playbook should be executed against at a single time

* Playbook execution strategy

  Whether the parallel playbook execution synchronizes on task boundaries

  - linear: *sync_execution*
  - free: *async_execution*

The [Ansible doc](http://docs.ansible.com/ansible/latest/playbooks_strategies.html) seems to suggest that *serial (rolling update batch size)* shall only be used together with the *linear (synchronized execution at task boundaries)* strategy, but it actually also makes sense for the *free (asynchronized execution)* strategy.

## Variables

## Role reuse

## Statistics

3482 issues
1225 PRs

