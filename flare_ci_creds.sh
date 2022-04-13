#!/usr/bin/env bash

ENC_COMMIT_MSG=$(node --eval 'console.log(encodeURIComponent(process.argv[1]))' "${BITRISE_GIT_MESSAGE}")

{
    echo build:flare --experimental_remote_merkle_tree_cache
    # don't use this for now, it can cause intermittent failures in some cases
    # echo build:flare --experimental_remote_cache_async
    echo build:flare --incompatible_remote_build_event_upload_respect_no_cache
    echo common:flare --remote_upload_local_results=false
    echo common:flare --experimental_remote_downloader=grpcs://cdn.bitrise.flare.build
    echo common:flare --remote_cache=grpcs://cdn.bitrise.flare.build
    echo common:flare --remote_timeout=600
    echo common:flare --remote_max_connections=1000
    echo common:flare --remote_local_fallback
    echo build:flare --experimental_stream_log_file_uploads
    echo build:flare --incompatible_remote_results_ignore_disk
    echo build:flare --bes_backend=grpcs://bes.bitrise.flare.build:443
    echo build:flare --bes_results_url='https://insights.bitrise.flare.build/invocations/'
    echo build:flare --bes_upload_mode=fully_async
    echo build:flare --remote_download_toplevel
    echo build --config=flare
    echo fetch --config=flare

    echo common:flare_ci --remote_upload_local_results=true
    echo common:flare_ci --disk_cache=
    echo common:flare_ci --repository_cache=

    # misc
    echo build --nobuild_runfile_links
    echo test --build_runfile_links

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