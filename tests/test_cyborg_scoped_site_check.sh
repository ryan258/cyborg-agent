#!/usr/bin/env bats
# test_cyborg_scoped_site_check.sh - Input validation for scoped site checks.

load helpers/test_helpers.sh
load helpers/assertions.sh

setup() {
    setup_test_environment
    export CYBORG_REPO="$TEST_DIR/cyborg-agent"
    mkdir -p "$CYBORG_REPO/scripts/lib"
    cp "$BATS_TEST_DIRNAME/../scripts/cyborg_scoped_site_check.sh" "$CYBORG_REPO/scripts/cyborg_scoped_site_check.sh"
    cp "$BATS_TEST_DIRNAME/../scripts/lib/config.sh" "$CYBORG_REPO/scripts/lib/config.sh"
    cp "$BATS_TEST_DIRNAME/../scripts/lib/common.sh" "$CYBORG_REPO/scripts/lib/common.sh"
    cp "$BATS_TEST_DIRNAME/../scripts/lib/file_ops.sh" "$CYBORG_REPO/scripts/lib/file_ops.sh"
    chmod +x "$CYBORG_REPO/scripts/cyborg_scoped_site_check.sh"
}

teardown() {
    teardown_test_environment
}

@test "scoped site check rejects non-content paths before running validators" {
    run "$CYBORG_REPO/scripts/cyborg_scoped_site_check.sh" ../secret.md

    [ "$status" -eq 2 ]
    [[ "$output" == *"Scoped site check only accepts content/ paths"* ]]
    [[ "$output" != *"uv:"* ]]
}

@test "scoped site check rejects traversal inside content paths before running validators" {
    run "$CYBORG_REPO/scripts/cyborg_scoped_site_check.sh" content/../secret.md

    [ "$status" -eq 2 ]
    [[ "$output" == *"must not contain '..'"* ]]
    [[ "$output" != *"uv:"* ]]
}
