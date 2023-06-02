#! /bin/bash
set -ix

mv include/* src/* .
rm -rf include src
tar zcf ../tt.tgz ./*
