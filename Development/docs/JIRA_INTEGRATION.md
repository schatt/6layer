# Jira Integration for CarManager Task Manager

This document explains how to export tasks from the CarManager task manager to Jira for better project management and collaboration.

## Overview

The CarManager project uses a custom task management system (ShrimpData/tasks.json) that tracks 187 tasks across different priorities and categories. This integration provides two methods to sync these tasks with Jira:

1. **CSV Export** - Export tasks to CSV for manual import into Jira
2. **REST API Integration** - Direct creation of Jira issues via API

## Method 1: CSV Export (Recommended for One-time Migration)

### Prerequisites
- Python 3.6+
- Access to Jira instance

### Usage

1. **Export all pending tasks:**
   ```bash
   python3 Scripts/export_to_jira.py --output jira_export.csv
   ```

2. **Export including completed tasks:**
   ```bash
   python3 Scripts/export_to_jira.py --output jira_export.csv --include-completed
   ```

3. **Custom output file:**
   ```bash
   python3 Scripts/export_to_jira.py --output my_jira_import.csv
   ```

### Output Format

The CSV file contains the following columns:
- **Summary** - Task name
- **Description** - Formatted task description with metadata
- **Issue Type** - Automatically determined (Bug, Story, Task, Improvement)
- **Priority** - Mapped from P0-P4 to Jira priorities
- **Status** - Current task status
- **Task ID** - Original task ID for reference
- **Dependencies** - Comma-separated list of dependent task IDs
- **Creation Time** - Task creation timestamp
- **Tags** - Task tags

### Import into Jira

1. Open your Jira project
2. Go to **Project Settings** → **Import**
3. Select **CSV** as import source
4. Upload the generated CSV file
5. Map CSV columns to Jira fields:
   - Summary → Summary
   - Description → Description
   - Issue Type → Issue Type
   - Priority → Priority
   - Status → Status
   - Task ID → Custom Field (if available)
   - Dependencies → Custom Field (if available)

## Method 2: REST API Integration (For Automated Sync)

### Prerequisites
- Python 3.6+
- `requests` library: `pip install requests`
- Jira API token
- Jira project access

### Setup

1. **Get Jira API Token:**
   - Go to https://id.atlassian.com/manage-profile/security/api-tokens
   - Create a new API token
   - Copy the token

2. **Install dependencies:**
   ```bash
   pip install requests
   ```

### Usage

1. **Test connection (dry run):**
   ```bash
   python3 Scripts/jira_api_integration.py \
     --jira-url https://your-domain.atlassian.net \
     --project-key CAR \
     --username your-email@example.com \
     --api-token your-api-token \
     --dry-run
   ```

2. **Create issues for pending tasks:**
   ```bash
   python3 Scripts/jira_api_integration.py \
     --jira-url https://your-domain.atlassian.net \
     --project-key CAR \
     --username your-email@example.com \
     --api-token your-api-token
   ```

3. **Include completed tasks:**
   ```bash
   python3 Scripts/jira_api_integration.py \
     --jira-url https://your-domain.atlassian.net \
     --project-key CAR \
     --username your-email@example.com \
     --api-token your-api-token \
     --include-completed
   ```

### Configuration

The script automatically:
- Maps task priorities (P0-P4) to Jira priorities
- Determines issue types based on task content
- Formats descriptions with metadata
- Adds labels for identification
- Preserves task dependencies

### Custom Fields

The script attempts to use custom fields for task metadata:
- `customfield_10001` - Task ID
- `customfield_10002` - Dependencies
- `customfield_10003` - Creation Time

If these fields don't exist in your Jira instance, the metadata will be included in the description.

## Task Priority Mapping

| Task Manager | Jira Priority |
|--------------|---------------|
| P0 (Critical) | Highest |
| P1 (High) | High |
| P2 (Medium) | Medium |
| P3 (Low) | Low |
| P4 (Lowest) | Lowest |

## Issue Type Determination

The scripts automatically determine issue types based on task content:

| Keywords | Issue Type |
|----------|------------|
| fix, bug, crash, error, issue | Bug |
| implement, add, create, build | Story |
| improve, optimize, enhance, refactor | Improvement |
| test, verify, validate | Task |
| (default) | Task |

## Current Task Statistics

As of the latest export:
- **Total Tasks:** 187
- **Pending:** 139
- **Completed:** 48
- **Issue Type Breakdown:**
  - Story: 64
  - Task: 60
  - Bug: 12
  - Improvement: 3

## Recommended Workflow

1. **Initial Setup:**
   - Create a new Jira project for CarManager
   - Configure issue types and priorities
   - Set up custom fields for task metadata (optional)

2. **One-time Migration:**
   - Use CSV export for initial migration
   - Review and adjust issue types/priorities in Jira
   - Link related issues manually

3. **Ongoing Sync:**
   - Use REST API integration for new tasks
   - Run export scripts periodically
   - Keep task IDs in sync between systems

## Troubleshooting

### CSV Export Issues
- **File not found:** Ensure `ShrimpData/tasks.json` exists
- **JSON errors:** Check task file format
- **Empty export:** Verify task status filtering

### API Integration Issues
- **Authentication failed:** Check username and API token
- **Project not found:** Verify project key
- **Permission denied:** Ensure user has project access
- **Custom field errors:** Ignore if custom fields don't exist

### General Issues
- **Encoding problems:** Ensure UTF-8 encoding
- **Large exports:** Consider filtering by status or priority
- **Dependency mapping:** May need manual linking in Jira

## Security Considerations

- Store API tokens securely
- Use environment variables for credentials
- Limit API token permissions
- Review exported data before import

## Future Enhancements

Potential improvements:
- Bidirectional sync (Jira → Task Manager)
- Automated dependency linking
- Status synchronization
- Comment/attachment sync
- Webhook integration for real-time updates

## Support

For issues with the integration scripts:
1. Check the troubleshooting section
2. Review script output for error messages
3. Verify Jira configuration
4. Test with a small subset of tasks first 