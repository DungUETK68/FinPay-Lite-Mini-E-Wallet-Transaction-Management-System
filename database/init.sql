CREATE EXTENSION IF NOT EXISTS "pgcrypto";

CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,

    role VARCHAR(20) NOT NULL DEFAULT 'USER',
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',

    phone VARCHAR(20),
    address TEXT,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_users_role 
        CHECK (role IN ('USER', 'ADMIN')),

    CONSTRAINT chk_users_status 
        CHECK (status IN ('ACTIVE', 'LOCKED', 'DELETED'))
);

CREATE TABLE wallets (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    user_id UUID NOT NULL UNIQUE,
    balance NUMERIC(18, 2) NOT NULL DEFAULT 0,
    currency VARCHAR(10) NOT NULL DEFAULT 'VND',

    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_wallets_user
        FOREIGN KEY (user_id)
        REFERENCES users(id),

    CONSTRAINT chk_wallets_balance
        CHECK (balance >= 0),

    CONSTRAINT chk_wallets_status
        CHECK (status IN ('ACTIVE', 'LOCKED'))
);

CREATE TABLE transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    from_wallet_id UUID,
    to_wallet_id UUID,

    amount NUMERIC(18, 2) NOT NULL,

    type VARCHAR(30) NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'PENDING',

    description TEXT,
    failure_reason TEXT,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_transactions_from_wallet
        FOREIGN KEY (from_wallet_id)
        REFERENCES wallets(id),

    CONSTRAINT fk_transactions_to_wallet
        FOREIGN KEY (to_wallet_id)
        REFERENCES wallets(id),

    CONSTRAINT chk_transactions_amount
        CHECK (amount > 0),

    CONSTRAINT chk_transactions_type
        CHECK (type IN ('TOPUP', 'TRANSFER', 'WITHDRAW', 'SAVING_DEPOSIT')),

    CONSTRAINT chk_transactions_status
        CHECK (status IN ('PENDING', 'SUCCESS', 'FAILED', 'REJECTED'))
);

CREATE TABLE saving_goals (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    user_id UUID NOT NULL,

    name VARCHAR(150) NOT NULL,
    target_amount NUMERIC(18, 2) NOT NULL,
    current_amount NUMERIC(18, 2) NOT NULL DEFAULT 0,

    deadline DATE,

    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_saving_goals_user
        FOREIGN KEY (user_id)
        REFERENCES users(id),

    CONSTRAINT chk_saving_goals_target_amount
        CHECK (target_amount > 0),

    CONSTRAINT chk_saving_goals_current_amount
        CHECK (current_amount >= 0),

    CONSTRAINT chk_saving_goals_status
        CHECK (status IN ('ACTIVE', 'COMPLETED', 'CANCELLED'))
);

CREATE TABLE loan_requests (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    user_id UUID NOT NULL,

    amount NUMERIC(18, 2) NOT NULL,
    purpose TEXT NOT NULL,
    monthly_income NUMERIC(18, 2),

    status VARCHAR(20) NOT NULL DEFAULT 'PENDING',

    reviewed_by UUID,
    reviewed_at TIMESTAMP,
    review_note TEXT,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_loan_requests_user
        FOREIGN KEY (user_id)
        REFERENCES users(id),

    CONSTRAINT fk_loan_requests_reviewed_by
        FOREIGN KEY (reviewed_by)
        REFERENCES users(id),

    CONSTRAINT chk_loan_requests_amount
        CHECK (amount > 0),

    CONSTRAINT chk_loan_requests_monthly_income
        CHECK (monthly_income IS NULL OR monthly_income >= 0),

    CONSTRAINT chk_loan_requests_status
        CHECK (status IN ('PENDING', 'APPROVED', 'REJECTED'))
);

CREATE TABLE audit_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    actor_id UUID,

    action VARCHAR(100) NOT NULL,
    target_type VARCHAR(50),
    target_id UUID,

    metadata JSONB,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_audit_logs_actor
        FOREIGN KEY (actor_id)
        REFERENCES users(id)
);

CREATE INDEX idx_users_email 
ON users(email);

CREATE INDEX idx_wallets_user_id 
ON wallets(user_id);

CREATE INDEX idx_transactions_from_wallet_id 
ON transactions(from_wallet_id);

CREATE INDEX idx_transactions_to_wallet_id 
ON transactions(to_wallet_id);

CREATE INDEX idx_transactions_created_at 
ON transactions(created_at);

CREATE INDEX idx_transactions_status 
ON transactions(status);

CREATE INDEX idx_saving_goals_user_id 
ON saving_goals(user_id);

CREATE INDEX idx_loan_requests_user_id 
ON loan_requests(user_id);

CREATE INDEX idx_loan_requests_status 
ON loan_requests(status);

CREATE INDEX idx_audit_logs_actor_id 
ON audit_logs(actor_id);

CREATE INDEX idx_audit_logs_created_at 
ON audit_logs(created_at);