# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

This is an information gathering and research repository that automatically collects, processes, and summarizes content from various tech news sources, blogs, and AI-related websites. The system tracks new articles since the last run and generates structured Markdown summaries organized by date.

## Core Architecture

### Data Flow
1. **Source Management**: `document_list.md` contains curated URLs of tech blogs, news sites, and AI resources
2. **State Tracking**: `last_run.txt` maintains the timestamp of the last execution to identify new content
3. **Content Processing**: WebFetch tool retrieves content, extracts publication dates, and generates summaries
4. **Output Generation**: Creates date-stamped folders (`YYYY-MM-DD/`) with structured Markdown files

### File Structure
- `document_list.md` - URL sources (# comments and blank lines are ignored)
- `last_run.txt` - Last execution timestamp for incremental processing
- `YYYY-MM-DD/` folders - Daily output containing:
  - `abstract.md` - Daily summary with one-line descriptions
  - `rumor.md` - Short-form/breaking news content
  - Individual article files named by title with detailed summaries

## Custom Commands

### `/daily_research_sync`
Primary automation command located in `.claude/commands/daily_research_sync.md`. Executes the full pipeline:
- Reads source URLs from `document_list.md`
- Compares publication dates against `last_run.txt`
- Fetches new content using WebFetch
- Generates structured summaries in date-stamped folders
- Updates execution timestamp

## Key Operations

When working with this repository:
- Always check `last_run.txt` before processing to determine the baseline date
- Use WebFetch for content retrieval rather than direct HTTP requests
- Maintain the established file naming convention for consistency
- Skip URLs that begin with `#` (comments) or are blank lines in `document_list.md`
- Generate summaries in structured Japanese format with source attribution

## Content Sources

The repository monitors tech industry sources including:
- General platforms (Zenn, Qiita, GitHub Trending)
- Major tech company blogs (OpenAI, Google Research, Anthropic, Meta AI, Microsoft AI)
- AI-focused publications (Ben's Bites, Simon Willison's Weblog, VentureBeat AI)

Sources are easily configurable by editing `document_list.md` with simple URL lists under category headers.