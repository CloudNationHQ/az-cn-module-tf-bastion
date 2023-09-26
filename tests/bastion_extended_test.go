package main

import (
	"context"
	"strings"
	"testing"

	"github.com/Azure/azure-sdk-for-go/sdk/azidentity"
	"github.com/Azure/azure-sdk-for-go/sdk/resourcemanager/network/armnetwork"
	"github.com/cloudnationhq/az-cn-module-tf-bastion/shared"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"
)

type bastionDetails struct {
	ResourceGroupName string
	Name              string
}

type ClientSetup struct {
	SubscriptionID string
	BastionClient  *armnetwork.BastionHostsClient
}

func (details *bastionDetails) GetBastion(t *testing.T, client *armnetwork.BastionHostsClient) *armnetwork.BastionHost {
	resp, err := client.Get(context.Background(), details.ResourceGroupName, details.Name, nil)
	require.NoError(t, err, "Failed to get bastion host")
	return &resp.BastionHost
}

func (setup *ClientSetup) InitializeBastionClient(t *testing.T, cred *azidentity.DefaultAzureCredential) {
	var err error
	setup.BastionClient, err = armnetwork.NewBastionHostsClient(setup.SubscriptionID, cred, nil)
	require.NoError(t, err, "Failed to create bastion client")
}

func TestBastion(t *testing.T) {
	t.Run("verrifyBastionHost", func(t *testing.T) {
		t.Parallel()

		cred, err := azidentity.NewDefaultAzureCredential(nil)
		require.NoError(t, err, "Failed to create credential")

		tfOpts := shared.GetTerraformOptions("../examples/complete")
		defer shared.Cleanup(t, tfOpts)
		terraform.InitAndApply(t, tfOpts)

		bastionMap := terraform.OutputMap(t, tfOpts, "bastion")
		subscriptionId := terraform.Output(t, tfOpts, "subscriptionId")

		bastionDetails := &bastionDetails{
			ResourceGroupName: bastionMap["resource_group_name"],
			Name:              bastionMap["name"],
		}

		ClientSetup := &ClientSetup{SubscriptionID: subscriptionId}
		ClientSetup.InitializeBastionClient(t, cred)
		bastion := bastionDetails.GetBastion(t, ClientSetup.BastionClient)

		t.Run("verifyBastionHost", func(t *testing.T) {
			verifyBastionHost(t, bastionDetails, bastion)
		})
	})
}

func verifyBastionHost(t *testing.T, details *bastionDetails, bastion *armnetwork.BastionHost) {
	t.Helper()

	require.Equal(
		t,
		details.Name,
		*bastion.Name,
		"Bastion host name does not match expected value",
	)

	require.Equal(
		t,
		"Succeeded",
		string(*bastion.Properties.ProvisioningState),
		"Bastion host provisioning state is not Succeeded",
	)

	require.True(
		t,
		strings.HasPrefix(details.Name, "bas"),
		"Bastion host name does not start with the right abbreviation",
	)
}
