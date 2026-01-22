import asyncio
import random
import websockets

# ---------------- CONFIG ----------------
PORT = 8765
DUST_THRESHOLD = 15000
MAX_CYCLES = 4
STATUS_INTERVAL = 1.0

# ---------------- STATE ----------------
dust = 12000
cleaning = False
client_connected = False
current_cycle = 0


# ---------------- HELPERS ----------------
def status_line():
    above = "YES" if dust > DUST_THRESHOLD else "NO"
    cleaning_state = "ACTIVE" if cleaning else "IDLE"
    return (
        f"STATUS:DUST:{dust},"
        f"TH:{DUST_THRESHOLD},"
        f"ABOVE:{above},"
        f"CLEANING:{cleaning_state},"
        f"CYCLE:{current_cycle}/{MAX_CYCLES}"
    )


async def send_event(ws, msg):
    await ws.send(f"EVENT:{msg}")


# ---------------- CLEANING SIMULATION ----------------
async def run_cleaning(ws):
    global cleaning, current_cycle

    cleaning = True
    current_cycle = 0

    await send_event(ws, "STARTING_CLEANING_PROCESS")

    # STEP 1: WATER SPRAY
    await send_event(ws, "STATUS:SPRAYING_WATER")
    await asyncio.sleep(5)
    await send_event(ws, "STATUS:WATER_SPRAYING_COMPLETE")

    # STEP 2: AGGRESSIVE CLEANING
    for i in range(1, MAX_CYCLES + 1):
        current_cycle = i
        await send_event(ws, f"CYCLE:{i}/{MAX_CYCLES}")
        await asyncio.sleep(2)

    # STEP 3: COMPLETE
    await send_event(ws, "STATUS:AGGRESSIVE_CLEANING_COMPLETE")

    cleaning = False
    current_cycle = 0

    await send_event(ws, "STATUS:WAITING_BEFORE_RESUME")
    await asyncio.sleep(10)
    await send_event(ws, "STATUS:RESUMING_MONITORING")


# ---------------- WEBSOCKET HANDLER ----------------
async def handler(ws):
    global dust, cleaning, client_connected

    client_connected = True
    print("Client connected")
    await ws.send("Welcome to Solar Panel Cleaner WebSocket Server")

    async def sender():
        global dust
        while True:
            dust = random.randint(12000, 18000)

            if dust > DUST_THRESHOLD and not cleaning:
                await send_event(ws, "ALERT: Dust threshold exceeded!")
                asyncio.create_task(run_cleaning(ws))

            try:
                await ws.send(status_line())
            except websockets.ConnectionClosed:
                break

            await asyncio.sleep(STATUS_INTERVAL)

    async def receiver():
        global cleaning
        try:
            async for msg in ws:
                cmd = msg.strip().upper()
                print("RX:", cmd)

                if cmd == "STATUS":
                    await ws.send(status_line())

                elif cmd == "START" and not cleaning:
                    asyncio.create_task(run_cleaning(ws))

                elif cmd == "STOP":
                    cleaning = False
                    await send_event(ws, "ALERT:AGGRESSIVE_CLEANING_FORCE_STOPPED")

                elif cmd == "TEST":
                    await ws.send("Test sweep completed")

        except websockets.ConnectionClosed:
            print("Client disconnected")

    await asyncio.gather(sender(), receiver())


# ---------------- MAIN ----------------
async def main():
    async with websockets.serve(handler, "0.0.0.0", PORT):
        print(f"Fake ESP32 WebSocket running on port {PORT}")
        await asyncio.Future()


if __name__ == "__main__":
    asyncio.run(main())
