-- Create the replication user with a password
DO
$$
BEGIN
   IF NOT EXISTS (
      SELECT FROM pg_catalog.pg_roles
      WHERE rolname = 'replica_user') THEN
      CREATE ROLE replica_user WITH REPLICATION LOGIN PASSWORD 'replica_password';
   END IF;
END
$$;

-- Grant CONNECT privilege on the user_activity db so replica_user can query
GRANT CONNECT ON DATABASE user_activity TO replica_user; 

-- Grant USAGE privilege for replica_user
GRANT USAGE ON SCHEMA public TO replica_user;

-- Grant SELECT privilege on tables to replica_user
GRANT SELECT ON ALL TABLES IN SCHEMA public TO replica_user;

-- Ensure default SELECT privileges are properly set
ALTER DEFAULT PRIVILEGES FOR ROLE primary_user IN SCHEMA public GRANT SELECT ON TABLES TO replica_user;

-- Initialize application schema
CREATE TABLE user_activity (
    -- activity_id SERIAL PRIMARY KEY,  -- Surrogate key, auto-incrementing
    user_id INT NOT NULL,            -- Can appear multiple times
    activity_timestamp TIMESTAMP NOT NULL,
    activity_type VARCHAR(50),
    details TEXT
);

-- Initial seed data
INSERT INTO user_activity (user_id, activity_timestamp, activity_type, details) VALUES
('39426207', '2024-06-29 08:43:11', 'device_enrollment', 'Device enrolled successfully (Model: iPhone 15)'),
('98253337', '2024-07-08 07:35:16', 'app_installed', 'App ''Secure Mail'' installed on device MacBook Air'),
('95252663', '2024-07-05 06:43:24', 'compliance_check', 'Device iPhone 15 failed compliance: outdated OS'),
('44650517', '2024-07-19 23:45:19', 'device_enrollment', 'New device Chromebook enrolled by user'),
('83308863', '2024-07-04 13:01:19', 'policy_applied', 'Policy ''Standard Security Policy'' applied to device iPad Pro'),
('44650517', '2024-07-19 23:45:27', 'device_locked', 'Remote lock command sent to Galaxy S24'),
('44650517', '2024-07-19 23:46:31', 'app_uninstalled', 'Removal of Microsoft Teams from MacBook Air'),
('98253337', '2024-07-19 17:39:43', 'device_wiped', 'Device Surface Pro wiped due to security breach'),
('39426207', '2024-07-01 00:15:53', 'policy_updated', 'Compliance policy ''Sales App Policy'' modified on Surface Pro'),
('14701348', '2024-07-01 06:03:54', 'remote_reboot', 'Remote reboot command sent to iPhone 15'),
('77775979', '2024-07-16 05:37:49', 'user_added_to_group', 'User 77775979 added to group ''Sales'''),
('77775979', '2024-07-16 05:38:33', 'firmware_update', 'Firmware updated on device MacBook Air'),
('39823468', '2024-06-20 20:52:48', 'device_inventory_update', 'Device MacBook Air reported new specs'),
('39426207', '2024-07-13 06:15:08', 'device_unenrollment', 'Device iPad Pro unenrolled by admin'),
('39823468', '2024-07-16 07:58:15', 'device_enrollment', 'Device enrolled successfully (Model: MacBook Air)'),
('11864343', '2024-06-25 02:27:25', 'compliance_check', 'Compliance status for MacBook Air is Pending'),
('14701348', '2024-07-01 06:04:27', 'app_deployed', 'App ''CRM App'' deployed to group ''IT Support'''),
('77775979', '2024-07-16 05:40:18', 'device_enrollment', 'New device Galaxy S24 enrolled by user'),
('95252663', '2024-07-05 06:44:21', 'password_reset', 'User 95252663 password reset via MDM'),
('11864343', '2024-07-13 15:31:17', 'device_locked', 'Device Galaxy S24 locked remotely'),
('83308863', '2024-07-04 13:02:38', 'admin_privileges_granted', 'Local admin access given to 83308863 on MacBook Air'),
('39823468', '2024-07-18 23:50:23', 'device_wiped', 'Full wipe initiated for Surface Pro'),
('95252663', '2024-07-08 07:52:31', 'remote_reboot', 'Device iPad Pro rebooted remotely'),
('83153526', '2024-07-02 04:25:06', 'app_installed', 'Installation of Company Portal completed on Chromebook'),
('58036346', '2024-06-15 07:47:23', 'app_uninstalled', 'App ''Expense Tracker'' uninstalled from device MacBook Air'),
('11864343', '2024-07-13 15:32:33', 'policy_applied', 'Security policy ''Sales App Policy'' enforced on Surface Pro'),
('58036346', '2024-07-10 14:37:34', 'device_wiped', 'Full wipe initiated for iPad Pro'),
('14625701', '2024-07-20 07:12:30', 'policy_updated', 'Policy ''Standard Security Policy'' updated on device iPhone 15'),
('98253337', '2024-07-19 17:41:20', 'device_inventory_update', 'Inventory updated for device iPhone 15'),
('15054518', '2024-07-10 13:28:57', 'certificate_deployed', 'Certificate ''Executive Access Policy'' deployed to device MacBook Air'),
('83153526', '2024-07-05 08:28:26', 'firmware_update', 'OS update initiated for iPhone 15'),
('14701348', '2024-07-04 01:25:30', 'vpn_configured', 'VPN configured on device iPhone 15'),
('95252663', '2024-07-15 16:19:24', 'app_uninstalled', 'App ''Secure Mail'' uninstalled from device iPhone 15'),
('58036346', '2024-07-10 14:38:09', 'device_locked', 'Device MacBook Air locked remotely'),
('83153526', '2024-07-20 16:44:04', 'policy_applied', 'Security policy ''Standard Security Policy'' enforced on Surface Pro'),
('39426207', '2024-07-18 18:50:30', 'policy_applied', 'Policy ''HR Data Policy'' applied to device MacBook Air'),
('15054518', '2024-07-10 13:29:28', 'device_inventory_update', 'Device Surface Pro reported new specs'),
('39426207', '2024-07-18 18:51:30', 'compliance_check', 'Device Galaxy S24 failed compliance: jailbroken/rooted'),
('95252663', '2024-07-15 16:20:20', 'firmware_update', 'Firmware updated on device iPhone 15'),
('58036346', '2024-07-16 11:45:09', 'device_unenrollment', 'User initiated unenrollment for iPad Pro'),
('14625701', '2024-07-20 07:14:16', 'location_tracked', 'Location update for iPad Pro: Lat 38.3585, Lon -76.8459'),
('39823468', '2024-07-18 23:50:30', 'admin_privileges_granted', 'Admin privileges granted to user 39823468 on device iPad Pro'),
('15054518', '2024-07-10 13:31:28', 'device_enrollment', 'New device iPhone 15 enrolled by user'),
('77775979', '2024-07-16 05:41:06', 'policy_updated', 'Compliance policy ''Standard Security Policy'' modified on Chromebook'),
('77775979', '2024-07-17 10:44:30', 'app_installed', 'Installation of Company Portal completed on Galaxy S24'),
('11864343', '2024-07-13 15:34:26', 'device_wiped', 'Device MacBook Air wiped due to security breach'),
('14625701', '2024-07-20 07:14:38', 'device_unenrollment', 'Device Chromebook unenrolled by admin'),
('44650517', '2024-07-19 23:47:41', 'device_locked', 'Remote lock command sent to Surface Pro'),
('52360837', '2024-07-02 17:44:32', 'firmware_update', 'OS update initiated for iPhone 15'),
('95252663', '2024-07-15 16:21:49', 'compliance_check', 'Device iPad Pro failed compliance: missing encryption'),
('14701348', '2024-07-11 11:33:51', 'device_enrollment', 'Device enrolled successfully (Model: Surface Pro)'),
('58036346', '2024-07-16 11:45:17', 'device_unenrollment', 'User initiated unenrollment for iPhone 15'),
('52360837', '2024-07-19 09:39:02', 'device_enrollment', 'Device enrolled successfully (Model: Galaxy S24)'),
('83153526', '2024-07-20 16:44:30', 'app_installed', 'App ''Secure Mail'' installed on device iPad Pro'),
('15054518', '2024-07-10 13:32:23', 'policy_applied', 'Policy ''Standard Security Policy'' applied to device Surface Pro'),
('83153526', '2024-07-20 16:45:58', 'device_wiped', 'Full wipe initiated for MacBook Air'),
('14701348', '2024-07-11 11:33:53', 'remote_reboot', 'Device iPhone 15 rebooted remotely'),
('39426207', '2024-07-18 18:53:09', 'policy_applied', 'Security policy ''Executive Access Policy'' enforced on iPad Pro'),
('11864343', '2024-07-13 15:35:28', 'vpn_configured', 'VPN settings updated for Chromebook'),
('11940305', '2024-06-25 00:01:15', 'device_wiped', 'Device MacBook Air wiped due to security breach'),
('39426207', '2024-07-18 18:54:25', 'device_enrollment', 'Device enrolled successfully (Model: Surface Pro)'),
('83153526', '2024-07-20 16:46:58', 'device_locked', 'Device iPad Pro locked remotely'),
('95252663', '2024-07-15 16:22:33', 'device_wiped', 'Full wipe initiated for Surface Pro'),
('11940305', '2024-06-25 00:02:34', 'device_inventory_update', 'Inventory updated for device iPhone 15'),
('83308863', '2024-07-04 13:02:40', 'policy_applied', 'Security policy ''HR Data Policy'' enforced on Chromebook'),
('95252663', '2024-07-15 16:23:59', 'compliance_check', 'Compliance status for Galaxy S24 is Non-Compliant'),
('77775979', '2024-07-17 10:45:39', 'app_uninstalled', 'App ''Company Portal'' uninstalled from device iPhone 15'),
('14701348', '2024-07-11 11:34:14', 'certificate_deployed', 'Wi-Fi certificate ''Standard Security Policy'' installed on Galaxy S24'),
('39823468', '2024-07-18 23:50:43', 'device_enrollment', 'New device iPad Pro enrolled by user'),
('39823468', '2024-07-18 23:51:13', 'app_installed', 'Installation of Expense Tracker completed on MacBook Air'),
('95252663', '2024-07-15 16:25:05', 'remote_reboot', 'Device iPhone 15 rebooted remotely'),
('39426207', '2024-07-18 18:55:06', 'policy_updated', 'Policy ''Standard Security Policy'' updated on device Galaxy S24'),
('11864343', '2024-07-13 15:36:51', 'device_enrollment', 'Device enrolled successfully (Model: Surface Pro)'),
('11864343', '2024-07-13 15:37:08', 'device_unenrollment', 'User initiated unenrollment for iPhone 15'),
('44650517', '2024-07-19 23:49:40', 'device_wiped', 'Device Chromebook wiped due to security breach'),
('14625701', '2024-07-20 07:16:00', 'device_inventory_update', 'Device Galaxy S24 reported new specs'),
('83308863', '2024-07-04 13:02:53', 'device_enrollment', 'Device enrolled successfully (Model: MacBook Air)'),
('39426207', '2024-07-18 18:56:20', 'app_deployed', 'App ''Company Portal'' deployed to group ''IT Support'''),
('44650517', '2024-07-19 23:50:09', 'app_installed', 'App ''Company Portal'' installed on device Galaxy S24'),
('11940305', '2024-06-25 00:03:33', 'device_locked', 'Remote lock command sent to Galaxy S24'),
('11940305', '2024-06-25 00:04:34', 'device_enrollment', 'New device iPhone 15 enrolled by user'),
('83153526', '2024-07-20 16:47:57', 'compliance_check', 'Compliance status for Chromebook is Compliant'),
('44650517', '2024-07-19 23:51:02', 'app_uninstalled', 'Removal of Secure Mail from MacBook Air'),
('11940305', '2024-06-25 21:30:35', 'app_installed', 'App ''Secure Mail'' installed on device Surface Pro'),
('14625701', '2024-07-20 07:17:17', 'policy_applied', 'Policy ''Executive Access Policy'' applied to device iPad Pro'),
('52360837', '2024-07-19 09:39:32', 'policy_updated', 'Compliance policy ''Standard Security Policy'' modified on MacBook Air'),
('44650517', '2024-07-19 23:51:32', 'device_unenrollment', 'User initiated unenrollment for iPhone 15'),
('15054518', '2024-07-10 13:32:46', 'certificate_deployed', 'Certificate ''Standard Security Policy'' deployed to device MacBook Air'),
('77775979', '2024-07-17 10:45:59', 'device_unenrollment', 'Device Surface Pro unenrolled by admin'),
('77775979', '2024-07-17 10:47:35', 'remote_reboot', 'Device iPad Pro rebooted remotely'),
('83153526', '2024-07-20 16:48:40', 'vpn_configured', 'VPN configured on device Chromebook'),
('98253337', '2024-07-19 17:42:35', 'admin_privileges_granted', 'Admin privileges granted to user 98253337 on device iPad Pro'),
('39823468', '2024-07-18 23:53:10', 'vpn_configured', 'VPN settings updated for Surface Pro'),
('58036346', '2024-07-16 11:46:38', 'compliance_check', 'Device iPad Pro failed compliance: outdated OS'),
('39426207', '2024-07-18 18:58:10', 'app_uninstalled', 'Removal of Secure Mail from Galaxy S24'),
('98253337', '2024-07-19 17:42:42', 'device_inventory_update', 'Inventory updated for device Galaxy S24'),
('14625701', '2024-07-20 07:17:29', 'device_wiped', 'Full wipe initiated for iPhone 15'),
('11940305', '2024-06-25 21:31:16', 'device_locked', 'Device MacBook Air locked remotely'),
('14701348', '2024-07-11 11:34:46', 'certificate_deployed', 'Wi-Fi certificate ''Guest Wi-Fi Policy'' installed on Chromebook'),
('39823468', '2024-07-18 23:54:14', 'vpn_configured', 'VPN configured on device Chromebook');

-- Create materialized view that will be used to access the count of daily active users
CREATE MATERIALIZED VIEW daily_active_users AS
SELECT
    CAST(activity_timestamp AS DATE) AS activity_date,
    COUNT(DISTINCT user_id) AS active_user_count
FROM
    user_activity
GROUP BY
    CAST(activity_timestamp AS DATE)
ORDER BY
    activity_date;
