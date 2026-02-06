"""
GLM-4.7 API Client for TSL Documentation Generation
"""
import json
import time
import requests
from typing import Optional
from dataclasses import dataclass

from config import (
    GLM_API_KEY,
    GLM_API_URL,
    GLM_CODING_URL,
    GLM_MODEL,
    USE_CODING_ENDPOINT,
    MAX_RETRIES,
    RETRY_DELAY,
    MAX_OUTPUT_TOKENS,
    TEMPERATURE
)


@dataclass
class GLMResponse:
    """Response from GLM API"""
    content: str
    reasoning_content: Optional[str]
    total_tokens: int
    model: str
    success: bool
    error: Optional[str] = None


class GLMClient:
    """Client for GLM-4.7 API"""

    def __init__(self, api_key: str = GLM_API_KEY, model: str = GLM_MODEL):
        self.api_key = api_key
        self.model = model
        # Use Coding endpoint if configured
        self.api_url = GLM_CODING_URL if USE_CODING_ENDPOINT else GLM_API_URL
        self.headers = {
            "Content-Type": "application/json",
            "Authorization": f"Bearer {api_key}"
        }
        self.total_tokens_used = 0
        self.request_count = 0
        print(f"Using API endpoint: {self.api_url}")

    def chat(
        self,
        user_message: str,
        system_message: str = "You are a helpful assistant specialized in analyzing TSL scripts for hsbCAD.",
        max_tokens: int = MAX_OUTPUT_TOKENS,
        temperature: float = TEMPERATURE
    ) -> GLMResponse:
        """
        Send a chat request to GLM-4.7

        Args:
            user_message: The user's message/prompt
            system_message: System prompt for context
            max_tokens: Maximum tokens in response
            temperature: Sampling temperature (0-1)

        Returns:
            GLMResponse with content and metadata
        """
        payload = {
            "model": self.model,
            "messages": [
                {"role": "system", "content": system_message},
                {"role": "user", "content": user_message}
            ],
            "max_tokens": max_tokens,
            "temperature": temperature
        }

        for attempt in range(MAX_RETRIES):
            try:
                response = requests.post(
                    self.api_url,
                    headers=self.headers,
                    json=payload,
                    timeout=120
                )

                if response.status_code == 200:
                    data = response.json()
                    choice = data["choices"][0]
                    message = choice["message"]
                    usage = data.get("usage", {})

                    # Track usage
                    tokens = usage.get("total_tokens", 0)
                    self.total_tokens_used += tokens
                    self.request_count += 1

                    return GLMResponse(
                        content=message.get("content", ""),
                        reasoning_content=message.get("reasoning_content"),
                        total_tokens=tokens,
                        model=data.get("model", self.model),
                        success=True
                    )
                else:
                    error_msg = f"API error {response.status_code}: {response.text}"
                    if attempt < MAX_RETRIES - 1:
                        print(f"Retry {attempt + 1}/{MAX_RETRIES}: {error_msg}")
                        time.sleep(RETRY_DELAY * (attempt + 1))
                    else:
                        return GLMResponse(
                            content="",
                            reasoning_content=None,
                            total_tokens=0,
                            model=self.model,
                            success=False,
                            error=error_msg
                        )

            except requests.exceptions.Timeout:
                if attempt < MAX_RETRIES - 1:
                    print(f"Timeout, retry {attempt + 1}/{MAX_RETRIES}")
                    time.sleep(RETRY_DELAY * (attempt + 1))
                else:
                    return GLMResponse(
                        content="",
                        reasoning_content=None,
                        total_tokens=0,
                        model=self.model,
                        success=False,
                        error="Request timeout after retries"
                    )

            except Exception as e:
                if attempt < MAX_RETRIES - 1:
                    print(f"Error, retry {attempt + 1}/{MAX_RETRIES}: {e}")
                    time.sleep(RETRY_DELAY * (attempt + 1))
                else:
                    return GLMResponse(
                        content="",
                        reasoning_content=None,
                        total_tokens=0,
                        model=self.model,
                        success=False,
                        error=str(e)
                    )

        return GLMResponse(
            content="",
            reasoning_content=None,
            total_tokens=0,
            model=self.model,
            success=False,
            error="Max retries exceeded"
        )

    def get_stats(self) -> dict:
        """Get usage statistics"""
        return {
            "total_tokens_used": self.total_tokens_used,
            "request_count": self.request_count,
            "average_tokens_per_request": (
                self.total_tokens_used / self.request_count
                if self.request_count > 0 else 0
            )
        }


def test_client():
    """Test the GLM client"""
    client = GLMClient()
    response = client.chat("1+1=?")

    print(f"Success: {response.success}")
    print(f"Content: {response.content}")
    print(f"Reasoning: {response.reasoning_content}")
    print(f"Tokens: {response.total_tokens}")
    print(f"Stats: {client.get_stats()}")


if __name__ == "__main__":
    test_client()
