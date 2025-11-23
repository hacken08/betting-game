import router from 'next/router';
import React, { useEffect, useState } from 'react'
import LoadingBar from 'react-top-loading-bar';

const LoadingPageIndicator = () => {

    const [progress, setProgress] = useState(0)

    useEffect(() => {
        router.events.on("routeChangeStart", () => {
            setProgress(40);
        });

        router.events.on("routeChangeComplete", () => {
            setProgress(100);
        });

    }, []);

    return (
        <div>
            <LoadingBar
                progress={progress} 
                onLoaderFinished={() => {
                    setProgress(0);
                }}
            />
        </div>
    )


}

export default LoadingPageIndicator
