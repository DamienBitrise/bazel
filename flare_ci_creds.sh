#!/usr/bin/env bash

ENC_COMMIT_MSG=$(node --eval 'console.log(encodeURIComponent(process.argv[1]))' "${BITRISE_GIT_MESSAGE}")

{
    echo common:flare --remote_header=x-api-key=${BITRISE_FLARE_KEY}
    echo common:flare --remote_header=x-flare-builduser=${BITRISE_FLARE_BUILD_USER}
    echo common:flare --bes_header=x-api-key=${BITRISE_FLARE_KEY}

    if [[ ${BITRISE_IO} -eq true ]]; then
        echo common:flare --build_metadata=CI=true
        echo common:flare --build_metadata=ci_build_id=${BITRISE_BUILD_NUMBER}
        echo common:flare --build_metadata=ci_build_url="${BITRISE_BUILD_URL}"
        #echo common:flare --build_metadata=ci_job_id=${BITRISE_????}
        echo common:flare --build_metadata=ci_message="${ENC_COMMIT_MSG}"
        echo common:flare --build_metadata=ci_pipeline_name="${BITRISE_APP_TITLE}"
    fi

} > user.bazelrc