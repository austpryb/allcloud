#! /usr/bin/env bash
#makecluster.sh

continueflag=0
while [ "$continueflag" -eq 0 ]
do
	environ="dev"
	min_size=3
	max_size=5
	company="fraxses"
	region=""
	cloud=""
	cpu=""


	cloudflag=0

	while [ "$cloudflag" -eq 0 ]
	do
	
		echo -n "Enter Cloud Provider [aws,google,azure]: "
		read cloud
		
		if [ "$cloud" == "aws" ] || [ "$cloud" == "google" ] || [ "$cloud" == "azure" ]
		then
			cloudflag=1
		else
			echo "Please enter one of the three providers in the brackets."
			echo ""
	
		fi
	done
	
	
	case "$cloud" in
		"google" )
			region="us-east1"
			cpu="";;
		"aws" )
			region="us-east-1"
			cpu="m5.2xlarge";;
		"azure" )
			region="eastus"
			cpu="Standard_A8_v2";;
	
	
	esac
	
	echo -n "Enter region[$region]: "
	read temp1
	
	if [ -n "$temp1" ]
	then
		region=$temp1
	fi
	
	
	
	echo -n "Enter environment type [$environ]: "
	read temp1
	if [ -n "$temp1" ]
	then
		environ=$temp1
	fi
	
	echo -n "Enter company name [$company]: "
	read temp1
	if [ -n "$temp1" ]
	then
		company=$temp1
	fi
	
	
	echo -n "Enter min size of cluster [$min_size]: "
	read temp1
	if [ -n "$temp1" ]
	then
		min_size=$temp1
	fi
	
	echo -n "Enter max size of cluster [$max_size]: "
	read temp1
	if [ -n "$temp1" ]
	then
		max_size=$temp1
	fi
	
	echo ""
	echo "company is" $company
	echo "environment type is" $environ
	echo "provider is" $cloud
	echo "region is" $region
	echo "size range is" $min_size "to" $max_size "nodes"
	echo ""
	echo -n "Is this correct? (y/n)"
	read temp1
	
	if [ "$temp1" == "y" ]
	then
		continueflag=1
	else
		echo "Starting variable assignment over."
		echo ""
	fi
done

clustername=fraxses-$company-$environ

function aws_run() {
	cd aws
	echo "please log into aws CLI"
	aws configure
	terraform init
	terraform plan
	terraform apply	


}

function azure_run() {
	cd azure
	echo "please log into azure CLI"
	az login
	terraform init
	terraform plan
	terraform apply
}

function google_run() {
	cd google
	echo "please log into google CLI"
	gcloud auth login

}


export TF_VAR_region=$region
export TF_VAR_cluster_name=$clustername
export TF_VAR_min_size=$min_size
export TF_VAR_max_size=$max_size
export TF_VAR_processor=$cpu

case "$cloud" in
	"google" )
		google_run ;;
	"aws" )
		aws_run ;;
	"azure" )
		azure_run ;;


esac



