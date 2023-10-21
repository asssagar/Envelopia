import { Container, Divider, Text } from "@chakra-ui/react";

export default function Footer() {
    return (
        <Container maxW={"100%"} mt={20} height={"100px"}>
            <Divider />
            <Container maxW={"1440px"} py={8}>
                <Text>Made with ❤️ @ Unfold Hackathon @2023</Text>
            </Container>
        </Container>
    );
}