# 0005: Streamlit as Primary Interface for Academic DBMS Evaluation

- **Status**: Superseded in part by ADR 0042
- **Date**: 2026-10-17
- **Context**:
  The course specification permits either a React.js web application or Streamlit.
  For the academic DBMS lab evaluation and viva, the examiners require live demonstrations of:
  1. Relational schema state, views, triggers, and atomic rollbacks in PostgreSQL.
  2. Unstructured JSON extraction candidates in MongoDB.
  3. Persona-swapping walkthroughs between the Owner and Claimant roles.
  Building a separate decoupled React single-page app introduces build-chain overhead, state synchronization complexity, and extra setup steps during viva evaluation.

- **Decision**:
  1. Use Streamlit as the primary interactive demo application, powered directly by shared Python backend service modules (SQLAlchemy, PyMongo, Pydantic, extraction pipeline).
  2. Structure the Streamlit app with two role-based portals:
     - Owner Portal (Estate setup, asset declaration, document upload, extraction candidate review, nominee and claimant designation).
     - Claimant Portal (Restricted view of assigned assets, release request submission, and step-by-step claim checklists).
  3. Retain modular service layers so FastAPI REST endpoints can expose the same functionality if external API consumption is needed.

- **Consequences**:
  - **Positive**: Rapid development, single-language stack (Python 3.11+), zero npm/node runtime dependencies for the lab demo, and instant data visualization.
  - **Trade-off**: Less flexibility for high-volume public commercial production UI than a custom React frontend, which is acceptable for an academic prototype.

- **Amendment (ADR 0042)**: The app contains sign-in/sign-out and only the Owner and Claimant portals. Reviewer/executor/admin and in-app DBMS Inspector screens are excluded; database inspection uses external tools.
