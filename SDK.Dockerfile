FROM ubuntu

RUN apt update && apt install -y curl git p7zip-full clang cmake

WORKDIR /root
ARG XCODE=7.3.1
ARG ADCDownloadAuth


# TODO find a way to just require userid+password and bake a fresh token from /signin
RUN if [ -z "${ADCDownloadAuth}" ]; then echo "Sign-in on https://developer.apple.com and collect ADCDownloadAuth cookie"; exit 1; fi

RUN curl "https://download.developer.apple.com/Developer_Tools/Xcode_${XCODE}/Xcode_${XCODE}.dmg" -H "cookie: ADCDownloadAuth=${ADCDownloadAuth}" -o /root/Xcode.dmg
RUN 7z x Xcode.dmg
RUN 7z x $(ls *.hfs)

RUN git clone https://github.com/tpoechtrager/osxcross.git
ENV UNATTENDED=1
ENV XCODEDIR=/root/Xcode.dmg
RUN /root/osxcross/tools/gen_sdk_package.sh

