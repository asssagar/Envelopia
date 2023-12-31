import { Container, Flex, Text } from "@chakra-ui/react";
import { ConnectWallet, useAddress } from "@thirdweb-dev/react";
import Link from "next/link";

export default function Navbar() {
    const address = useAddress();

    return (
        <Container maxW={"1440px"} py={4}>
            <Flex flexDirection={"row"} justifyContent={"space-between"} alignItems={"center"}>
                <Link href={"/"}>
                    <Text fontWeight={"black"}>Envelopia 💌</Text>
                </Link>
                {address && (
                    <Flex flexDirection={"row"}>
                        <Link href={"/transfer"}>
                            <Text mr={8}>Transfer</Text>
                        </Link>
                        <Link href={"/claim"}>
                            <Text mr={8}>Claim Token</Text>
                        </Link>
                        <Link href={`/profile/${address}`}>
                            <Text>My Account</Text>
                        </Link>
                        <Link href={"/bridge"}>
                            <Text>Bridge</Text>
                        </Link>
                    </Flex>
                )}
                <ConnectWallet/>
            </Flex>
        </Container>
    )
}