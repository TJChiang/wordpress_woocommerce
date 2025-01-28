import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
    stages: [
        { duration: '30s', target: 10 },
        { duration: '1m', target: 50 },
        { duration: '10s', target: 0 },
    ],
    thresholds: {
        http_req_duration: ['p(95)<500'], // 95% 的請求應在 500ms 以內
    },
};

const BASE_URL = __ENV.BASE_URL !== undefined ? __ENV.BASE_URL : 'http://localhost/';

export default function () {
    const res = http.get(`${BASE_URL}`);
    check(res, {
        'status is 200': (r) => r.status === 200,
        'response time < 500ms': (r) => r.timings.duration < 500,
    });
}

export function handleSummary(data) {
    return {
        '/logs/summary.json': JSON.stringify(exportData(data)),
        '/logs/raw.json': JSON.stringify(data),
        // 'stdout': textSummary(data, { indent: ' ', enableColors: true }),
    };
}

function exportData(data) {
    let checks = {};
    data.root_group.checks.forEach((check) => {
        checks[check.name] = {
            'passes': check.passes,
            'fails': check.fails,
        };
    });

    return {
        'group': data.root_group.name,
        'checks': checks,
        'field': data.options.summaryTrendStats,
        'checks_summary': data.metrics.checks.values,
        'request_count': data.metrics.http_reqs.values.count,
        'request_sending': data.metrics.http_req_sending.values,
        'request_receiving': data.metrics.http_req_receiving.values,
        'request_waiting': data.metrics.http_req_waiting.values,
        'request_duration': data.metrics.http_req_duration.values,
        'request_failed_rate': data.metrics.http_req_failed.values.rate,
        'virtual_users_min': data.metrics.vus.values.min,
        'virtual_users_max': data.metrics.vus.values.max,
    };
}
