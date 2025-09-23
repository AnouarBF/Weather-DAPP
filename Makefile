-include .env

build:; forge build

clean:; forge clean

deploy-sepolia:
	forge script script/DeployWeather.s.sol:DeployWeather \
	--fork-url ${SEPOLIA_RPC_URL} \
	--account foxyBoy \
	--broadcast \