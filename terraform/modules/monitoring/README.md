# Monitoring Module

This directory is reserved for the production observability layer.

The current lab focused on PostgreSQL HA, Patroni failover, etcd quorum,
NLB routing and recovery testing.

A production implementation would add CloudWatch and/or Prometheus metrics,
alerting, synthetic PostgreSQL connectivity checks and HA-specific alarms.
